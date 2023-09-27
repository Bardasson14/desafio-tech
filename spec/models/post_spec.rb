# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :content }
  end

  describe 'associations' do
    it { should belong_to :user }
    it { should have_many :comments }
  end

  describe 'scopes' do
    describe '.filter_by_title' do
      it 'should return [ Post(title="Post 2 (discussão)") ]' do
        query_result = Post.filter_by_title 'discussao'
        expect(query_result.pluck(:id)).to eq Post.where(title: 'Post 2 (discussão)').pluck(:id)
      end
    end

    describe '.filter_by_content' do
      it 'should return [ Post(content= "Conteúdo bônus do Post Alternativo") ]' do
        query_result = Post.filter_by_content 'bonus'
        expect(query_result.pluck(:id)).to eq Post.where(content: 'Conteúdo bônus do Post Alternativo').pluck(:id)
      end
    end

    describe '.filter_by_user_id' do
      it 'should return [ Post(user_id=2) ]' do
        query_result = Post.filter_by_user_id 2
        expect(query_result.pluck(:id)).to eq Post.where(user_id: 2).pluck(:id)
      end
    end
  end
end
