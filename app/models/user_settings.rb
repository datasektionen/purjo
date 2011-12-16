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

  def subscribe_to_comments
    @settings[:subscribe_to_comments] ||= @person.subscribe_to_comments
  end

  def subscribe_to_comments=(value)
    @settings[:subscribe_to_comments] = value
  end

  def has_unprocessed_newsletter?
    last_subscription = person.newsletter_subscriptions.order(:created_at.desc).first
    
    last_subscription.present? && last_subscription.state == 'unprocessed'
  end
  
  def save!
    @person.has_chosen_settings = true
    Rails.logger.info(@settings)
    handle_newsletter_subscription
    handle_post_comments_subscription
    
    @person.save!
  end
  
  def persisted?
    false
  end

private
  def handle_newsletter_subscription
    subscription = @person.newsletter_subscriptions.active
    if @settings[:subscribe] == "1" && subscription.nil?
      subscription = @person.newsletter_subscriptions.create!
      subscription.send_later(:process)
    end

    if @settings[:subscribe] == "0" && subscription.present?
      subscription.deactivate!
    end
  end

  def handle_post_comments_subscription
    Rails.logger.info("subscribe to comments: #{subscribe_to_comments}")
    @person.subscribe_to_comments = @settings[:subscribe_to_comments]
  end
end
