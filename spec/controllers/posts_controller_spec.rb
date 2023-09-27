# frozen_string_literal: true

RSpec.describe PostsController, type: :request do
  include AuthHelper

  fixtures :users
  fixtures :posts

  context 'authenticated' do
    before(:each) do
      admin_user = users :admin
      sign_in admin_user
      @default_post = posts :default
      @regular_user = users :regular
    end

    describe '#index' do
      it 'should return all posts' do
        get posts_path(format: :json)
        serialized_posts = ActiveModelSerializers::SerializableResource.new(Post.all,
                                                                            each_serializer: PostSerializer).to_json
        expect(response.body).to eq(serialized_posts)
      end
    end

    describe '#show' do
      it 'should return Post(id=1)' do
        get post_path(@default_post, format: :json)
        serialized_post = ActiveModelSerializers::SerializableResource.new(@default_post,
                                                                           each_serializer: PostSerializer).to_json
        expect(response.body).to eq(serialized_post)
      end
    end

    describe '#create' do
      context 'valid Post' do
        it 'should be created' do
          post_params = {
            post: {
              title: 'Novo Post',
              content: 'Conteúdo do Post',
              user_id: @regular_user.id
            }
          }

          post posts_path(format: :json), params: post_params
          expect(response.code).to eq '200'
        end
      end

      context 'invalid Post' do
        it 'should return server error' do
          post_params = {
            'post': {
              title: 'Post Inválido'
            }
          }

          post posts_path(format: :json), params: post_params
          expect(response.code).to eq '500'
        end
      end
    end

    describe '#update' do
      context 'valid Post' do
        it 'should be updated' do
          title = 'Novo Título Atualizado Post 1'
          post_params = { post: { title: } }

          patch post_path(@default_post, format: :json), params: post_params

          expect(@default_post.reload.title).to eq title
          expect(response.code).to eq '200'
        end
      end

      context 'invalid Post' do
        it 'should return server error' do
          title = ''
          post_params = { post: { title: } }

          patch post_path(@default_post, format: :json), params: post_params

          expect(response.code).to eq '500'
        end
      end
    end

    describe '#destroy' do
      context 'existing Post' do
        it 'should be removed' do
          delete post_path(@default_post, format: :json)

          expect(Post.find_by(id: @default_post.id)).to eq nil
          expect(response.code).to eq '200'
        end
      end
    end
  end

  context 'unauthenticated' do
    before(:each) do
      @default_post = posts :default
      @regular_user = users :regular
    end

    describe '#index' do
      it 'should return all posts' do
        get posts_path(format: :json)
        serialized_posts = ActiveModelSerializers::SerializableResource.new(Post.all,
                                                                            each_serializer: PostSerializer).to_json
        expect(response.body).to eq(serialized_posts)
      end
    end

    describe '#show' do
      it 'should return Post(id=1)' do
        get post_path(@default_post, format: :json)
        serialized_post = ActiveModelSerializers::SerializableResource.new(@default_post,
                                                                           each_serializer: PostSerializer).to_json
        expect(response.body).to eq(serialized_post)
      end
    end

    describe '#create' do
      context 'new Post' do
        it 'should not be persisted' do
          post_params = {
            post: {
              title: 'Novo Post',
              content: 'Conteúdo do Post',
              user_id: @regular_user.id
            }
          }

          post posts_path(format: :json), params: post_params
          expect(response.code).to eq '401'
        end
      end
    end

    describe '#update' do
      context 'existing Post' do
        it 'should not be updated' do
          original_title = @default_post.title
          post_params = {
            post: {
              title: 'Novo Título Post 1'
            }
          }

          patch post_path(@default_post, format: :json), params: post_params

          expect(@default_post.reload.title).to eq original_title
          expect(response.code).to eq '401'
        end
      end
    end

    describe '#destroy' do
      context 'existing User' do
        it 'should remain undestroyed' do
          delete post_path(@default_post, format: :json)

          expect(Post.find_by(id: @default_post.id)).not_to eq nil
          expect(response.code).to eq '401'
        end
      end
    end
  end
end
