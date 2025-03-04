require 'rails_helper'

RSpec.describe Event, type: :model do

  event = FactoryBot.build(:event)
  context 'Creating an event for a club' do
    
    it 'should create with validations' do
      
      binding.pry
      

      expect(event.valid?).to eq(true)
      binding.pry

    end
  end
end