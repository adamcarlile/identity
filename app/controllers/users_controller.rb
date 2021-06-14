class UsersController < ApplicationController

  def show
    redirect_to sessions_path unless logged_in?
  end

end