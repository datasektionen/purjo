class AddStateToNewsletter < ActiveRecord::Migration
  def self.up
    add_column :newsletters, :state, :string
  end

  def self.down
    remove_column :newsletters, :state
  end
end
