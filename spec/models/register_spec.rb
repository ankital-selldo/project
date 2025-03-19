require 'rails_helper'


RSpec.describe Register, type: :model do

  context "Registering for event" do
    register = FactoryBot.build(:register)
    
    it "student when registering for an event " do
      expect(register.valid?).to eq(true)
    end
  end

  context 'Related objects checking' do
    register = FactoryBot.build(:register_without_event_existing)

    it "must delete the registerations of an event when event is deleted" do
      expect(register.valid?).to eq(false)
    end

  end

  context 'checking for invalid fields' do

    register = FactoryBot.build(:registering_when_link_is_absent)

    # it 'must be invalid registeration' do
    #   expect(register.valid?).to eq(false)
    # end
  end

end