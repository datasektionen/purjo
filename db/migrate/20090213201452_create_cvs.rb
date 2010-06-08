class CreateCvs < ActiveRecord::Migration
  def self.up
    create_table :cvs do |t|
      t.string :name
      t.string :mail
      t.string :phone
      t.integer :birth_year
      t.integer :study_start
      t.integer :planned_exam
      t.string :orientation
      t.text :personal
      t.text :ambitions
      t.text :employment
      t.text :education
      t.text :other_commitments
      t.text :language_skills

      t.timestamps
    end
  end

  def self.down
    drop_table :cvs
  end
end
