class AddItSkillsToCvs < ActiveRecord::Migration
  def self.up
    add_column :cvs, :it_skills, :text
  end

  def self.down
    remove_column :cvs, :it_skills
  end
end
