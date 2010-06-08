class AddLanguageToCvs < ActiveRecord::Migration
  def self.up
    add_column :cvs, :language, :string

    Cv.all.each do |cv|
      cv.language = "sv"
      cv.save!
    end
  end

  def self.down
    remove_column :cvs, :language
  end
end
