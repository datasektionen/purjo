class MergeStudentsToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :chapter, :string
    add_column :people, :gender, :string
    add_column :people, :homedir, :string
    
    Person.reset_column_information
    
    Person.transaction do
      Student.all.each do |student|
      
        person = Person.find_by_kth_ugid(student.uid)
    
        if person.nil?
          first_name, last_name = student.name.split("\s")
          person = Person.new(
            :first_name => first_name,
            :last_name => (last_name || "N/A"),
            :email => student.email,
            :gender => student.gender,
            :cell_phone_number => student.phone_mobile
          )
        
        end  
      
        person.gender = student.gender
        person.chapter = student.sektion
        person.homedir = student.homedir
        
        begin
          person.save!
        rescue
          puts "#{person.inspect} is invalid: "
          puts person.errors.inspect
          puts "student: #{student.inspect}"
        end
        
      end
    end
    
    drop_table :students
  end

  def self.down
    raise "down-migrations is a myth..."
  end
end
