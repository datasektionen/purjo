class AddDateToNewsletter < ActiveRecord::Migration
  def self.up
    change_table :newsletters do |t|
      t.datetime :sent
    end
  end

  def self.down
    change_table :newsletters do |t|
      t.remove :sent
    end
  end
end
