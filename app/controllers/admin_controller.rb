class AdminController < ApplicationController
  require_role :editor

  def index
  end
end
