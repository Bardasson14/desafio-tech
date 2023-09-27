# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :content }
  end

  describe 'associations' do
    it { should belong_to :post }
  end
end
