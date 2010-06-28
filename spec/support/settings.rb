Purjo2::Application.settings = ActiveSupport::HashWithIndifferentAccess.new({
  :newsletter_template_id => HominidHelpers::TemplateId,
  :newsletter_list_id => HominidHelpers::ListId,
  :newsletter_api_key => HominidHelpers::ApiKey,
  :newsletter_from_email => "info@example.com",
  :newsletter_from_name => "Informationsministeriet",
  :newsletter_to_email => "info@example.com",
  :ldap_host =>  "localhost",
  :show_n_days_in_calendar => 60
})
