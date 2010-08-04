class CommitteesController < InheritedResources::Base
  require_role :admin
end