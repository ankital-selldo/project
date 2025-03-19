require 'rails_helper'

RSpec.describe Club, type: :model do
  # let(:club) { FactoryBot.build(:club) }
  club = FactoryBot.build(:club2)
  
  context "Creating a club" do

    it 'crates a club with valid equals true status' do

      expect(club.valid?).to eq(true)
    end

    it "when creating club with validations" do
      if club.club_logo.blank?

        puts "empty"
      end
      
      expect(club).to be_valid

    end

    # it "when club logo empty set default" do
      
    #   if club.club_logo
    #     binding.pry
    #     club.club_logo = club.club_name
        
    #     expect(club.valid?).to eq(true)
    #     binding.pry
    #   end

    # end
  end
end