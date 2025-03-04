require 'rails_helper'

RSpec.describe Student, type: :model do
  student = FactoryBot.build(:student4)
  
  context 'validations' do
    it 'is valid with valid attributes' do
      # er = student.errors.full_messages
      # er.each do |error|
      #   puts error
      # end
      puts student.valid?
      expect(student).to be_valid
    end
    
    it 'is not valid without a name' do
      student.email = "12345"

      # THis means that student should not be valid
      expect(student.valid?).to eq(false)
    end
    
  end
end