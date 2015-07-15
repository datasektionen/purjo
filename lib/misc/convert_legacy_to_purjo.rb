# encoding: utf-8
require 'mysql'
require 'iconv'

# conversion-config.yaml: Konfigfil enligt:
# legacy:
#   database: d-legacy
#   username: root
#   password: passvoid
#   hostname: 127.0.0.1
$options = HashWithIndifferentAccess.new(YAML.load_file("#{RAILS_ROOT}/conversion-config.yaml"))

TagMap = {
  'DIU' => 'DIU',
  'Dam' => 'Sektionen',
  'DSEKT' => 'Sektionen',
  'DKM' => 'DKM',
  'SPEX' => 'Spex',
  'DT07' => 'Sektionen',
  'ESC' => 'ESCapo',
  'Extern' => 'Extern',
  'IOR' => 'IOR',
  'JUB' => 'Sektionen',
  'Jam' => 'Jämn',
  'Mot' => 'Mottagningen',
  'PR' => 'Näringsliv',
  'Prylis' => 'Prylis',
  'QN' => 'QN',
  'Redak' => 'Redaktionen',
  'Idrott' => 'Idrott',
  'SN' => 'SN',
  'STUDS' => 'Studs',
  'SVL' => 'SVL',
  'Val' => 'Val'
}

def legacy_text_to_textile(text)
  text.gsub!(/^!/, "h2. ")
  text.gsub!(/^!!/, "h3. ")
  text.gsub!(/^!!!/, "h4. ")
  text.gsub!(/^!!!!/, "h5. ")
  
  text.gsub!(/==\s*(.*?)\s*==/, 'h2. \1')
  text.gsub!(/===\s*(.*?)\s*===/, 'h3. \1')
  text.gsub!(/====\s*(.*?)\s*====/, 'h4. \1')
  text.gsub!(/=====\s*(.*?)\s*=====/, 'h5. \1')
  text.gsub!(/=======\s*(.*?)\s*=======/, 'h6. \1')
  
  text.gsub!(/'''(.*?)'''/, "*\1*")
  text.gsub!(/''(.*?)''/, "_\1_")
  
  text.gsub!(/\[\[(.*)\|(.*)\]\]/, "\"\\1\":\\2")
  text
end

def convert_text(text)
  if $options[:encoding]
    Iconv.conv($options[:encoding][:to], $options[:encoding][:from], text)
  else
    text
  end
end

mysql = Mysql.init
mysql.connect(
  ($options[:legacy][:hostname] || "localhost"),
  $options[:legacy][:username],
  $options[:legacy][:password],
  $options[:legacy][:database])

sections = {}
sections_results = mysql.query("SELECT * FROM Sections")
while (section_hash = sections_results.fetch_hash)
  sections[section_hash['id']]  = section_hash
end

users = {}
users_results = mysql.query("SELECT * FROM Users")
while (user_hash = users_results.fetch_hash)
  users[user_hash['id']] = user_hash
end

news_results = mysql.query("SELECT * FROM News")

news_posts = {}

NewsPost.transaction do
  begin
    while (news_hash = news_results.fetch_hash)
      news_hash['section_id'] = "55" if news_hash['section_id'] == "0"
      
      puts users[news_hash['user_id']]['username']
      person = Person.find_or_import(users[news_hash['user_id']]['username'])
      
      if person.nil? || person == false
        raise "NoSuchPersonException: #{news_hash['user_id']}"
      end
      
      person.save!
      
      post = Post.create!(
        :expires_at => news_hash['expiry_date'],
        :created_at => news_hash['create_date'],
        :updated_at => news_hash['create_date'],
        :content => convert_text(legacy_text_to_textile(news_hash['text'])),
        :name => convert_text(news_hash['header']),
        :news_post => true,
        :created_by => person
      )
      
      news_posts[news_hash['id']] = post
      
      post.category_list = TagMap[sections[news_hash['section_id']]['short_name']]
      post.save!
    end
  rescue Iconv::InvalidEncoding => e
    puts news_hash['header']
    next
  rescue => e
    puts e.class
    raise
  end
end

calender_results = mysql.query("SELECT * FROM Calendar")

CalendarPost.transaction do
  while (calendar_hash = calender_results.fetch_hash)
    begin
      
      person = Person.find_or_import(users[calendar_hash['user_id']]['username'])
      
      if !person 
        raise "NoSuchPersonException: #{calendar_hash['user_id']}/#{users[calendar_hash['user_id']]['username']}"
      end
      
      person.save!
      
      post = nil
      
      if calendar_hash['news_id'] != nil
        post = news_posts[calendar_hash['news_id']]
      else
        post = Post.new(
          :name => convert_text(calendar_hash['title']),
          :content => convert_text(legacy_text_to_textile(calendar_hash['description'])),
          :created_by => person
        )
      end

      post.update_attributes(
        :starts_at => calendar_hash['startdate'], 
        :ends_at => calendar_hash['enddate'],
        :all_day => calendar_hash['showtime'] == "1" ? false : true,
        :calendar_post => true
      )
      
      post.save!
    rescue => e
      puts e.inspect
    end
  end
end