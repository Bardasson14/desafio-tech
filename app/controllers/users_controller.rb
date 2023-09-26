# frozen_string_literal: true

class UsersController < CollectionsController

  private
  
  def allowed_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
