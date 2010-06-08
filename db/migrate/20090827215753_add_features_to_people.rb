class AddFeaturesToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :serialized_features, :text
  end

  def self.down
    remove_column :people, :serialized_features
  end
end
