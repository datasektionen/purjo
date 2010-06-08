class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :cell_phone_number
      t.string :kth_ugid
      t.string :kth_username

      t.timestamps
    end
    
    add_index(:people, :kth_ugid, :unique => true)
    add_index(:people, :kth_username, :unique => true)
  end

  def self.down
    drop_table :people
  end
end
