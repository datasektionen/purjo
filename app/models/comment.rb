class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  validates_presence_of :text
  acts_as_textiled :text
end
