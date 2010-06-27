class CreateNewsletterSections < ActiveRecord::Migration
  def self.up
    create_table :newsletter_sections do |t|
      t.string :title
      t.text :body
      t.integer :newsletter_id
      t.timestamps
    end
  end

  def self.down
    drop_table :newsletter_sections
  end
end
