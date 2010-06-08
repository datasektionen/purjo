class AddImInfoToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :msn, :string
    add_column :people, :xmpp, :string
  end

  def self.down
    remove_column :people, :xmpp
    remove_column :people, :msn
  end
end
