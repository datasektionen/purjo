class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.integer :id
      t.string :first_name
      t.string :last_name
      t.string :username_nada
      t.string :username_kth
      t.string :phone
      t.string :plan
      t.string :sektion
      t.string :adress
      t.string :xfinger

      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
