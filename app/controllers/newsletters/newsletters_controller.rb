class NewslettersController < InheritedResources::Base
  
  def create
    create! { newsletters_path }
  end
  
  def deliver
    @test_delivery = TestDelivery.new(@newsletter)
  end
end
