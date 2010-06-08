class ChangeTypeOfIdToText < ActiveRecord::Migration
  def self.up
    add_column :students, :uid, :string
  end

  def self.down
    remove_column :students, :uid
  end
end

