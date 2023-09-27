# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do

  fixtures :users
  fixtures :posts
  fixtures :comments
  
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :content }
  end

  describe 'associations' do
    it { should belong_to :post }
  end

  describe 'scopes' do
    describe '.filter_by_post_id' do
      it 'should return [ Comment(post_id=1) ]' do
        query_result = Comment.filter_by_post_id 1
        expect(query_result.pluck(:id)).to eq Comment.where(post_id: 1).pluck(:id)
      end
    end

    describe '.filter_by_name' do
      it 'should return [ Comment(name="Usuário alternativo") ]' do
        query_result = Comment.filter_by_name 'usuario alt'
        expect(query_result.pluck(:id)).to eq Comment.where(name: 'Usuário alternativo').pluck(:id)
      end
    end

    describe '.filter_by_content' do
      it 'should return [ Comment(content="Discordo do Post de discussão") ]' do
        query_result = Comment.filter_by_content 'discussao'
        expect(query_result.pluck(:id)).to eq Comment.where(content: 'Discordo do Post de discussão').pluck(:id)
      end
    end
  end
end
