class AddMorePersonalInfoToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :personalemail, :string
  end

  def self.down
    remove_column :people, :personalemail
  end
end
