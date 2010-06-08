class CreateJobAds < ActiveRecord::Migration
  def self.up
    create_table :job_ads do |t|
      t.string :title
      t.string :company
      t.text :description
      t.integer :created_by_id
      t.date :start_date
      t.date :end_date
      t.boolean :part_time
      t.boolean :full_time
      t.boolean :thesis
      t.datetime :expires_at

      t.timestamps
    end
  end

  def self.down
    drop_table :job_ads
  end
end
