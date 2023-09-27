# frozen_string_literal: true

RSpec.describe CommentsController, type: :request do
  include AuthHelper

  fixtures :users
  fixtures :posts
  fixtures :comments

  context 'unauthenticated' do
    before(:each) do
      @default_comment = comments :default
      @regular_user = users :regular
    end

    describe '#index' do
      it 'should return all comments' do
        get comments_path(page: 1, per_page: 100, format: :json)
        serialized_comments = ActiveModelSerializers::SerializableResource.new(Comment.all,
                                                                               each_serializer: CommentSerializer).to_json
        expect(response.body).to eq(serialized_comments)
      end
    end

    describe '#show' do
      it 'should return Comment(id=1)' do
        get comment_path(@default_comment, format: :json)
        serialized_comment = ActiveModelSerializers::SerializableResource.new(@default_comment,
                                                                              each_serializer: CommentSerializer).to_json
        expect(response.body).to eq(serialized_comment)
      end
    end

    describe '#create' do
      context 'valid Comment' do
        it 'should be created' do
          comment_params = {
            comment: {
              name: 'Novo Usuário Convidado',
              content: 'Novo Comentário',
              post_id: 1
            }
          }

          post comments_path(format: :json), params: comment_params
          expect(response.code).to eq '200'
        end
      end

      context 'invalid Comment' do
        it 'should return server error' do
          comment_params = {
            'comment': {
              content: 'Comentário Inválido'
            }
          }

          post comments_path(format: :json), params: comment_params
          expect(response.code).to eq '500'
        end
      end
    end

    describe '#update' do
      context 'valid Comment' do
        it 'should be updated' do
          content = "Comentário atualizado #{Date.today}"
          comment_params = { comment: { content: } }

          patch comment_path(@default_comment, format: :json), params: comment_params

          expect(@default_comment.reload.content).to eq content
          expect(response.code).to eq '200'
        end
      end

      context 'invalid Content' do
        it 'should return server error' do
          comment_params = { comment: { content: '' } }
          original_content = @default_comment.content

          patch comment_path(@default_comment, format: :json), params: comment_params

          expect(@default_comment.reload.content).to eq original_content
          expect(response.code).to eq '500'
        end
      end
    end

    describe '#destroy' do
      context 'existing Content' do
        it 'should be removed' do
          delete comment_path(@default_comment, format: :json)

          expect(Comment.find_by(id: @default_comment.id)).to eq nil
          expect(response.code).to eq '200'
        end
      end
    end
  end
end
