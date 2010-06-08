class Change < ActiveRecord::Base
  belongs_to :changed_by, :class_name => 'Person'
  belongs_to :changed_object, :polymorphic => true
  
  validates_presence_of :changed_object_id, :changed_by_id
  validates_inclusion_of :action, :in => %w( update create )
end
