# frozen_string_literal: true

class UsersController < CollectionsController
  def create
    user = User.new allowed_params
    user.jti = SecureRandom.uuid # setting up JTI

    if user.save
      render json: user, serializer: UserSerializer
    else
      render json: {
        message: user.errors.full_messages.uniq.join(', ')
      }, status: :internal_server_error
    end
  end

  private

  def allowed_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
