class AddOrderToNewsletterSections < ActiveRecord::Migration
  def self.up
    add_column :newsletter_sections, :order, :integer
  end

  def self.down
    remove_column :newsletter_sections, :order
  end
end
