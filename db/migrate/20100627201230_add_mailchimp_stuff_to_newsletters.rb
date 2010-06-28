class AddMailchimpStuffToNewsletters < ActiveRecord::Migration
  def self.up
    add_column :newsletters, :campaign_id, :string
  end

  def self.down
    remove_column :newsletters, :campaign_id
  end
end
