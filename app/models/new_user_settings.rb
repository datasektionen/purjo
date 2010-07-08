class NewUserSettings
  include ActiveModel::Validations
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  
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
      @person.newsletter_subscriptions.create!
    end
    @person.save!
  end
  
  def persisted?
    false
  end
  
end