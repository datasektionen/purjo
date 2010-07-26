class AddDefaultValueToOrderInNewsletterSections < ActiveRecord::Migration
  def self.up
    change_column :newsletter_sections, :order, :integer, :default => 99, :null => false
  end

  def self.down
    change_column :newsletter_sections, :order, :integer
  end
end
