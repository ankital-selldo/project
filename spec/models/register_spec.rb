# require 'rails_helper'


# RSpec.describe Register, type: :model do

#   context "Registering for event" do
#     register = FactoryBot.build(:register)
    
#     it "student when registering for an event " do
#       expect(register.valid?).to eq(true)
#     end
#   end

#   context 'Related objects checking' do
#     register = FactoryBot.build(:register_without_event_existing)

#     it "must delete the registerations of an event when event is deleted" do
#       expect(register.valid?).to eq(false)
#     end

#   end

#   context 'checking for invalid fields' do

#     register = FactoryBot.build(:registering_when_link_is_absent)

#     # it 'must be invalid registeration' do
#     #   expect(register.valid?).to eq(false)
#     # end
#   end

# end


require 'rails_helper'

RSpec.describe Register, type: :model do
  let(:student) { FactoryBot.create(:student, email: "ron2@gmail.com") }
  let(:event) { FactoryBot.create(:event) }

  describe "Validations" do
    it "is valid with valid attributes" do
      register = Register.new(name: "John", branch: "CSE", year: "SE", student: student, event: event)
      expect(register).to be_valid
    end

    it "is invalid without a name" do
      register = Register.new(name: "", branch: "CSE", year: "SE", student: student, event: event)
      expect(register).not_to be_valid
      expect(register.errors[:name]).to include("can't be blank")
    end

    it "is invalid if name contains numbers" do
      register = Register.new(name: "John123", branch: "CSE", year: "SE", student: student, event: event)
      expect(register).not_to be_valid
      expect(register.errors[:name]).to include("should not contain numbers")
    end

    it "is invalid if name is less than 2 characters" do
      register = Register.new(name: "J", branch: "CSE", year: "SE", student: student, event: event)
      expect(register).not_to be_valid
      expect(register.errors[:name]).to include("is too short (minimum is 2 characters)")
    end

    it "is invalid without a branch" do
      register = Register.new(name: "John", branch: "", year: "SE", student: student, event: event)
      expect(register).not_to be_valid
      expect(register.errors[:branch]).to include("can't be blank")
    end

    it "is invalid without a year" do
      register = Register.new(name: "John", branch: "CSE", year: "", student: student, event: event)
      expect(register).not_to be_valid
      expect(register.errors[:year]).to include("can't be blank")
    end

    it "is invalid if year is not FE, SE, TE, or BE" do
      register = Register.new(name: "John", branch: "CSE", year: "XYZ", student: student, event: event)
      expect(register).not_to be_valid
      expect(register.errors[:year]).to include("should be one of 'FE', 'SE', 'TE', 'BE'")
    end

    it "is invalid without a student" do
      register = Register.new(name: "John", branch: "CSE", year: "SE", student: nil, event: event)
      expect(register).not_to be_valid
      expect(register.errors[:student]).to include("can't be blank")
    end

    it "is invalid without an event" do
      register = Register.new(name: "John", branch: "CSE", year: "SE", student: student, event: nil)
      expect(register).not_to be_valid
      expect(register.errors[:event]).to include("can't be blank")
    end
  end

end
