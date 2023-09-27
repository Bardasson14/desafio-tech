# frozen_string_literal: true

RSpec.describe Users::SessionsController, type: :request do
  include AuthHelper

  fixtures :users

  describe '#create' do
    context 'valid user' do
      it 'should be signed in' do
        user = users :admin
        serialized_user = ActiveModelSerializers::SerializableResource.new(user, serializer: UserSerializer).to_json
        http_login user.email, 'admin123'
        expect(response.body).to eq serialized_user
      end
    end

    context 'invalid user' do
      it 'should remain unauthenticated' do
        http_login 'invalid@user.com', 'wrongpassword'
        expect(response.code).to eq '401'
      end
    end
  end
end
