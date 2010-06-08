class ChangesController < ApplicationController
  require_role "admin"
  def index
    @changes = Change.all(:order => 'created_at DESC')
  end
end
