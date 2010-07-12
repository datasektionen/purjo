class NewsletterSubscription < ActiveRecord::Base
  belongs_to :person
  
  state_machine :state, :initial => :unprocessed do
    
    before_transition :unprocessed => :active, :do => :subscribe
    
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
  
  def subscribe
    hominid.subscribe(
      Purjo2::Application.settings[:newsletter_list_id],
      person.email
    )
  end
  
  def hominid
    Hominid::Base.new(:api_key => Purjo2::Application.settings[:newsletter_api_key])
  end
end
