RSpec::Matchers.define :have_success_message do
  match do |page|
    page.should have_css("div#flash_notice")
  end
  
  failure_message_for_should do |actual|
    "expected that the page should contain a success message, but it didn't"
  end

  failure_message_for_should_not do |actual|
    "expected that the page should not contain a sucess message, but it did"
  end
end

