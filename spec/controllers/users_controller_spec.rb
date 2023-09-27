# frozen_string_literal: true

RSpec.describe UsersController, type: :request do
  include AuthHelper

  fixtures :users

  context 'authenticated' do
    before(:each) do
      @admin_user = users :admin
      sign_in @admin_user
    end

    describe '#index' do
      it 'should return all users' do
        get users_path(format: :json)
        serialized_users = ActiveModelSerializers::SerializableResource.new(User.all,
                                                                            each_serializer: UserSerializer).to_json
        expect(response.body).to eq(serialized_users)
      end
    end

    describe '#show' do
      it 'should return User(id=1)' do
        get user_path(@admin_user, format: :json)
        serialized_user = ActiveModelSerializers::SerializableResource.new(@admin_user,
                                                                           each_serializer: UserSerializer).to_json
        expect(response.body).to eq(serialized_user)
      end
    end

    describe '#create' do
      context 'valid User' do
        it 'should be created' do
          user_params = {
            user: {
              name: 'Novo Usuário Teste',
              email: 'new_test_user@test.com',
              password: 'Senha 123'
            }
          }

          post users_path(format: :json), params: user_params
          expect(response.code).to eq '200'
        end
      end

      context 'invalid User' do
        it 'should return server error' do
          user_params = {
            'user': {
              name: 'Usuário Inválido'
            }
          }

          post users_path(format: :json), params: user_params
          expect(response.code).to eq '500'
        end
      end
    end

    describe '#update' do
      context 'valid User' do
        it 'should be updated' do
          name = 'Novo Nome p/ Usuário Teste Admin'
          user_params = {
            user: { name: }
          }

          patch user_path(@admin_user, format: :json), params: user_params
          expect(@admin_user.reload.name).to eq name
        end
      end

      context 'invalid User' do
        it 'should return server error' do
          user_params = {
            'user': {
              email: '@.com'
            }
          }

          patch user_path(@admin_user, format: :json), params: user_params
          expect(response.code).to eq '500'
        end
      end
    end

    describe '#destroy' do
      context 'existing User' do
        it 'should be removed' do
          regular_user = users :regular
          regular_user_id = regular_user.id
          delete user_path(regular_user, format: :json)

          expect(User.find_by(id: regular_user_id)).to eq nil
        end
      end
    end
  end

  context 'unauthenticated' do
    before(:each) do
      @admin_user = users :admin
    end

    describe '#index' do
      it 'should return all comments' do
        get users_path(format: :json)
        serialized_users = ActiveModelSerializers::SerializableResource.new(User.all,
                                                                            each_serializer: UserSerializer).to_json
        expect(response.body).to eq(serialized_users)
      end
    end

    describe '#show' do
      it 'should return User(id=1)' do
        get user_path(@admin_user, format: :json)
        serialized_user = ActiveModelSerializers::SerializableResource.new(@admin_user,
                                                                           each_serializer: UserSerializer).to_json
        expect(response.body).to eq(serialized_user)
      end
    end

    describe '#create' do
      context 'new User' do
        it 'should not be persisted' do
          user_params = {
            user: {
              name: 'Usuário Inválido'
            }
          }

          post users_path(format: :json), params: user_params

          expect(response.code).to eq '401'
        end
      end
    end

    describe '#update' do
      context 'existing User' do
        it 'should not be updated' do
          original_name = @admin_user.name
          user_params = {
            user: {
              name: 'Nome Válido'
            }
          }

          patch user_path(@admin_user, format: :json), params: user_params

          expect(@admin_user.reload.name).to eq original_name
          expect(response.code).to eq '401'
        end
      end
    end

    describe '#destroy' do
      context 'existing User' do
        it 'should remain undestroyed' do
          regular_user = users :regular
          delete user_path(regular_user, format: :json)

          expect(regular_user.reload).not_to eq nil
          expect(response.code).to eq '401'
        end
      end
    end
  end
end
