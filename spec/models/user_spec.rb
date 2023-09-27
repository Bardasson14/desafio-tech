# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do

  fixtures :users

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'associations' do
    it { should have_many :posts }
  end

  describe 'scopes' do
    describe '.filter_by_name' do
      it 'should return [ User(name="João González") ]' do
        query_result = User.filter_by_name 'zal'
        expect(query_result.pluck(:id)).to eq User.where(name: 'João González').pluck(:id)
      end
    end
    
    describe '.filter_by_email' do
      it 'should return [ User(email=joao_gonzalez@user.com) ]' do
        query_result = User.filter_by_email 'gonzalez'
        expect(query_result.pluck(:id)).to eq User.where(email: 'joao_gonzalez@user.com').pluck(:id)
      end
    end
  end
end
