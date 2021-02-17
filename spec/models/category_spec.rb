require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'Associations' do
    it { should have_many(:items).dependent(:destroy) }
  end

  context 'Validation tests' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title) }
  end
end
