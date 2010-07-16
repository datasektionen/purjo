class NewsletterSubscription < ActiveRecord::Base
  
  include Ior::Hominid::Common
  belongs_to :person
  
  state_machine :state, :initial => :unprocessed do
    
    before_transition :unprocessed => :active, :do => :subscribe_to_mailchimp
    before_transition :active => :inactive, :do => :unsubscribe_from_mailchimp
    
    state :unprocessed
    state :active
    state :inactive
    
    event :process do
      transition :unprocessed => :active
    end
    
    event :deactivate do
      transition :active => :inactive
    end
  end
  
  def subscribe_to_mailchimp
    hominid.subscribe(
      Purjo2::Application.settings[:newsletter_list_id],
      person.email
    )
  end
  
  def unsubscribe_from_mailchimp
    hominid.unsubscribe(
      Purjo2::Application.settings[:newsletter_list_id],
      person.email
    )
  end
end
