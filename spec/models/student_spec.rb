require 'rails_helper'

RSpec.describe Student, type: :model do
  student = FactoryBot.build(:student4)
  
  context 'validations' do
    it 'is valid with valid attributes' do
      
      expect(student).to be_valid
    end
    
    it 'is not valid without a name' do
      student.name = "12345"

      # THis means that student should not be valid
      expect(student.valid?).to eq(false)
    end

    it 'is not valid without a email' do
      student.email = ""

      # THis means that student should not be valid
      expect(student.valid?).to eq(false)
    end
    
    it 'is not valid without a password' do
      student.password = "1234568"

      # THis means that student should not be valid
      expect(student.valid?).to eq(false)
    end

    it 'is not valid without a name' do
      student.role = "hr"

      # THis means that student should not be valid
      expect(student.valid?).to eq(false)
    end
  end
end