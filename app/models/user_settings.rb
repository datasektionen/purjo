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
    @settings[:newsletter]
  end
  
  def save!
    @person.has_chosen_settings = true
    if @settings[:newsletter]
      subscription = @person.newsletter_subscriptions.create!
      subscription.send_later(:process)
    end
    @person.save!
  end
  
  def persisted?
    false
  end
  
end