# frozen_string_literal: true

module AuthHelper
  def http_login(email, password)
    post user_session_path(format: :json), params: {
      user: { email:, password: }
    }.to_json, headers: { 'Content-Type': 'application/json' }
  end

  def http_logout(token)
    delete destroy_user_session_path(format: :json), headers: {
      'Authorization': token,
      'Content-Type': 'application/json'
    }
  end
end
