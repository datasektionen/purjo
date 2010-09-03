require 'active_record/base_without_table'

class ContactMail < ActiveRecord::BaseWithoutTable
  # sender info
  column :name, :string
  column :email, :string
  column :message, :text

  attr_writer :subject
  def subject
    @subject || "Meddelande via hemsidan"
  end

  validates_presence_of :name, :email, :subject, :message
  validates_format_of :email,
    :with => /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\Z/i

  validate :at_least_one_recipient

  # recipients (objects)
  attr_reader :recipient_id, :recipient
  def recipient=(v)
    @recipient = v
    @recipient_id = "#{v.class.to_s.underscore}_#{v.id}" unless v.nil?
  end
  # form input value (in the format of ":class_:id")
  def recipient_id=(v)
    @recipient_id = v
    # set @recipient to matching object
    match = v.match(/\A([a-z]+(_[a-z]+)*)_(\d+)\Z/)
    if !match.nil?
      classified = match[1].camelize.constantize
      @recipient = classified.find(match[3].to_i)
    end
  end

  protected

  def at_least_one_recipient
    if recipient.nil? or recipient == "" or (recipient.is_a?(Array) and recipient.empty?)
      errors.add(:base, "Ingen mottagare har specificerats!")
    end
  end
end

