# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    include RackSessions

    respond_to :json

    def respond_with(current_user, _opts = {})
      render json: current_user, serializer: UserSerializer
    end

    def respond_to_on_destroy
      if request.headers['Authorization'].present?
        jwt_payload = JWT.decode(
          request.headers['Authorization'].split(' ').last,
          Rails.application.credentials.devise_jwt_secret_key!
        ).first

        current_user = User.find(jwt_payload['sub'])
      end

      if current_user
        render json: { message: 'Logout feito com sucesso.' }, status: :ok
      else
        render json: { message: 'Sessão não encontrada.' }, status: :unauthorized
      end
    end
  end
end
