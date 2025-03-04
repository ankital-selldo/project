require 'rails_helper'


RSpec.describe Register, type: :model do

  context "Registering for event" do
    register = FactoryBot.build(:register)
    
    it "student when registering for an event " do
      expect(register.valid?).to eq(true)
    end
  end
end