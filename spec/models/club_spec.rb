require 'rails_helper'

RSpec.describe Club, type: :model do
  # let(:club) { FactoryBot.build(:club) }
  club = FactoryBot.build(:club)
  
  context "Creating a club" do

    it "when creating club with validations" do
      if club.club_logo.blank?

        puts "empty"
      end
      puts club.club_name
      puts club.club_logo
      binding.pry
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