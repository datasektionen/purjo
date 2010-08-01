require 'active_record/base_without_table'

class ContactMail < ActiveRecord::BaseWithoutTable
  # sender info
  column :name, :string
  column :email, :string
  column :message, :text

  validates_presence_of :name, :email, :message
  validates_format_of :email,
    :with => /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\Z/i

  validate :at_least_one_recipient

  # recipients
  attr_writer :committees, :posts
  def committees
    @committees || []
  end
  def posts
    @posts || []
  end

  # array of email addresses to send to
  def recipients
    recipients = []
    @committees.each do |p|
      r = Committee.find(p.to_i)
      recipients << r if r
    end
    @posts.each do |p|
      r = ChapterPost.find(p.to_i)
      recipients << r if r
    end
    recipients
  end

  protected

  def at_least_one_recipient
    if self.committees.empty? && self.posts.empty?
      errors.add_to_base("Ingen mottagare har specificerats!")
    end
  end
end

