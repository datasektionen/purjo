require 'active_record/base_without_table'

class ContactMail < ActiveRecord::BaseWithoutTable
  column :to, :string
  column :name, :string
  column :email, :string
  column :message, :text

  validates_presence_of :name, :message
  validates_format_of :email,
    :with => /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\Z/i,
    :message => "är ogiltig"
  validates_length_of :message, :minimum => 5, :message => 'är för kort'
end

