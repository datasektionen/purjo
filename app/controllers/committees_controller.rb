class CommitteesController < InheritedResources::Base
  require_role :admin
  
  def create
    create! { committees_path }
  end
  
  def update
    update! { committees_path }
  end
end