namespace :backup do
  desc "Backups the production database to app/backups."
  task :invoke, :roles => :app do
    require 'yaml'

    filename = "#{shared_path}/backup/#{Time.now.strftime('%Y%m%d%H%M%S')}.sql.bz2"

    run("cat #{shared_path}/config/database.yml") do |channel, stream, data|
      config = YAML::load(data)['production']
      
      run("mysqldump --defaults-file=/home/capistrano/db.cnf #{config['database']} | bzip2 -c > #{filename}")
    end
  end
  
  desc "Copy the production database to staging"
  task :mirror_staging, :roles => :app do
    config = YAML::load_file("config/database.yml")
    
    run("cat #{shared_path}/config/database.yml") do |channel, stream, data|
      config = YAML::load(data)
      
      if config['staging'].nil?
        raise "No staging environment set on the server"
      end
      
      filename = "#{shared_path}/backup/#{Time.now.strftime('%Y%m%d%H%M%S')}.sql.bz2"
    
      run("mysqldump --defaults-file=/home/capistrano/db.cnf #{config['production']['database']} > #{filename}")
      run("cat #{filename} | mysql --defaults-file=/home/capistrano/db.cnf #{config['staging']['database']}")
    end
    
  end
  
  desc "Mirror the production database to the local production database."
  task :mirror, :roles => :app do
    config = YAML::load_file("config/database.yml")['production']
    
    run "ls -1 #{shared_path}/backup/ | tail -n 1" do |channel, stream, data|
      data.strip!

      get "#{shared_path}/backup/#{data}", "/tmp/#{data}"
      
      socket = config['socket'] ? "-S #{config['socket']}" : ""
      mysql_user_stuffs = "-u#{config['username']} --password=#{config['password']} #{socket}"
      
      `bunzip2 /tmp/#{data}`
      
      `mysql #{mysql_user_stuffs} -e 'DROP DATABASE \`#{config['database']}\`'`
      `mysql #{mysql_user_stuffs} -e 'CREATE DATABASE \`#{config['database']}\`'`
      
      `mysql #{mysql_user_stuffs} #{config['database']} < /tmp/#{File.basename(data, ".bz2")}`
      
      `rm /tmp/#{File.basename(data, ".bz2")}*`
    end
  end
  before "backup:mirror", "backup:invoke"
  
end
