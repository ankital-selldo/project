require 'rails_helper'

RSpec.describe Event, type: :model do

  context 'Creating an event for a club & checking the validations for it' do
    event = FactoryBot.build(:event)
    
    it 'should create with validations' do
      expect(event.valid?).to eq(true)
    end

    it 'must be invalid record' do
      event.event_desc = ""
      expect(event.valid?).to eq(false)
    end

    it 'should be invalid event for past deadline date' do

      event.event_date = '1999-03-11'
      expect(event.valid?).to eq(false)
    end

    it 'should be invalid event for when event deadline is before event_start date' do

      event.event_date = '2025-03-20'
      event.event_deadline = '2024-03-21'
      expect(event.valid?).to eq(false)
    end
  end

  context 'checking for dependent objects of event those are registerations' do

    event = FactoryBot.build(:event_of_a_non_existing_club)

    it 'should be invalid' do
      expect(event.valid?).to eq(false)
    end

    
      
  end

  
end