require 'rails_helper'

RSpec.describe AccessCode, type: :model do
  describe ".verify_admin_code" do
    context "when the correct admin code is provided" do
      it "returns true" do
        expect(AccessCode.verify_admin_code("ADMIN_SECRET_2025")).to be true
      end
    end

    context "when an incorrect admin code is provided" do
      it "returns false" do
        expect(AccessCode.verify_admin_code("WRONG_CODE")).to be false
      end
    end
  end

  describe ".verify_club_head_code" do
    context "when the correct club head code is provided" do
      it "returns true" do
        expect(AccessCode.verify_club_head_code("CLUB_HEAD_2025")).to be true
      end
    end

    context "when an incorrect club head code is provided" do
      it "returns false" do
        expect(AccessCode.verify_club_head_code("WRONG_CODE")).to be false
      end
    end
  end
end
