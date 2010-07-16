class UserSettings
  include ActiveModel::Validations
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  
  attr_reader :person
  
  def initialize(person, settings = {})
    @settings = settings
    @person = person
  end
  
  def newsletter=(value)
    @settings[:newsletter] = value
  end
  
  def newsletter
    @settings[:newsletter].present? ? @settings[:newsletter] : person.newsletter_subscriptions.active.present?
  end
  
  def has_unprocessed_newsletter?
    last_subscription = person.newsletter_subscriptions.order(:created_at.desc).first
    
    last_subscription.present? && last_subscription.state == 'unprocessed'
  end
  
  def save!
    @person.has_chosen_settings = true
    
    active_newsletter_subscription = @person.newsletter_subscriptions.active
    
    if @settings[:newsletter] == "1" && active_newsletter_subscription.nil?
      subscription = @person.newsletter_subscriptions.create!
      subscription.send_later(:process)
    end
    
    if @settings[:newsletter] == "0" && active_newsletter_subscription.present?
      active_newsletter_subscription.deactivate!
    end
    
    @person.save!
  end
  
  def persisted?
    false
  end
  
end