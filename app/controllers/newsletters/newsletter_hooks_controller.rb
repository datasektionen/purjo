class NewsletterHooksController < ApplicationController
  protect_from_forgery :except => :mailchimp_endpoint
  before_filter :check_secret_key
  
  def mailchimp_endpoint
    if params[:type].present?
      case params[:type]
      when 'unsubscribe'
        @person = Person.find_by_email(params[:data][:email])

        @person.newsletter_subscriptions.active.deactivate!
      else
        raise "Unknown mailchimp hook type"
      end
    end
  
    render :nothing => true
  end
  
  private
  def check_secret_key
    params[:secret] == Purjo2::Application.settings[:mailchimp_hook_secret]
  end
end

