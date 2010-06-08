class RemovePlanFromStudents < ActiveRecord::Migration
  def self.up
    remove_column :students, :plan
  end

  def self.down
    add_column :students, :plan, :string
  end
end
