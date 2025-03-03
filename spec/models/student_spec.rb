require 'rails_helper'

RSpec.describe Student, type: :model do
  let(:student) { build(:student) }
  
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(student.valid?).to eq(true)
    end
    
    it 'is not valid without a name' do
      student.name = nil

      # THis means that student should not be valid
      expect(student.valid?).to eq(false)
    end
    
  end
end