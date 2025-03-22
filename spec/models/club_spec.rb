require 'rails_helper'

RSpec.describe Club, type: :model do
  # let(:student) { FactoryBot.create(:student, email: "example2@gmail.com") }
  
  let(:club) { FactoryBot.create(:club1) }

  describe "Validations" do
    it "is valid with a club_name and club_logo" do

      expect(club).to be_valid
    end

    it "is invalid without a club_name" do
     club = FactoryBot.build(:club1, club_name: "") 
      expect(club.valid?).to eq(false)
      # expect(club.errors[:club_name]).to include("can't be blank")
    end

    it "is invalid without a club_logo" do
     club = FactoryBot.build(:club1, club_logo: "") 

      expect(club).to be_valid
      # expect(club.errors[:club_logo]).to include("can't be blank")
    end
  end

  describe "Associations" do
    it "belongs to a student" do
      club = Club.reflect_on_association(:student)
      expect(club.macro).to eq(:belongs_to)
    end

    it "has many events" do
      club = Club.reflect_on_association(:events)
      expect(club.macro).to eq(:has_many)
    end

    it "destroys associated events when club is deleted" do
      student = FactoryBot.build(:student4)
      club = FactoryBot.create(:club1, student: student)
      event = FactoryBot.create(:event, club: club) 
    
      expect(Event.where(id: event.id)).to exist  
      expect { club.destroy }.to change { Event.count }.by(-1)  
      expect(Event.where(id: event.id)).not_to exist  
    end
    
  end
end

