require 'rails_helper'

RSpec.describe Item, type: :model do
  context 'Associations' do
    it { should belong_to(:category) }
  end

  context 'Validation tests' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name) }

    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount) }
  end
end
