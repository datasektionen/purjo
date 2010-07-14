Purjo2::Application.settings = ActiveSupport::HashWithIndifferentAccess.new({
  :newsletter_template_id => Ior::Hominid::TestBase::TemplateId,
  :newsletter_list_id => Ior::Hominid::TestBase::ListId,
  :newsletter_api_key => Ior::Hominid::TestBase::ApiKey,
  :newsletter_from_email => "info@example.com",
  :newsletter_from_name => "Informationsministeriet",
  :newsletter_to_email => "info@example.com",
  :newsletter_hominid_class_name => 'Ior::Hominid::TestBase',
  :mailchimp_hook_secret => "this is secret",
  :ldap_host =>  "localhost",
  :show_n_days_in_calendar => 60,

})
