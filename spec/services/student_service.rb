require 'rails_helper'

RSpec.describe StudentService, type: :service do
  let(:student) { create(:student, email: "kay@gmail.com" ,role: "admin", password: "Password@123", password_confirmation: "Password@123") }

  describe "#call" do
    context "when upgrading to admin with valid code" do
      before do
        allow(AccessCode).to receive(:verify_admin_code).with("valid_admin_code").and_return(true)
      end

      it "upgrades the student to admin and updates the password" do
        service = StudentsService.new(student, "admin", "valid_admin_code", "Password@123", "Password@123")
        expect(service.call).to be true
        expect(student.reload.role).to eq("admin")
        expect(student.authenticate("Password@123")).to be_truthy
      end
    end

    context "when upgrading to club_head with valid code" do
      before do
        allow(AccessCode).to receive(:verify_club_head_code).with("valid_club_code").and_return(true)
      end

      it "upgrades the student to club_head and updates the password" do
        service = StudentsService.new(student, "club_head", "valid_club_code", "Password@123", "Password@123")
        expect(service.call).to be true
        expect(student.reload.role).to eq("club_head")
        expect(student.authenticate("Password@123")).to be_truthy
      end
    end

    context "when upgrading with an invalid admin code" do
      before do
        allow(AccessCode).to receive(:verify_admin_code).with("invalid_code").and_return(false)
      end

      it "does not upgrade the role" do
        service = StudentsService.new(student, "admin", "invalid_code", "Password@123", "Password@123")
        expect(service.call).to be false
      end
    end

    context "when upgrading with an invalid club_head code" do
      before do
        allow(AccessCode).to receive(:verify_club_head_code).with("invalid_code").and_return(false)
      end

      it "does not upgrade the role" do
        service = StudentsService.new(student, "club_head", "invalid_code", "Password@123", "Password@123")
        expect(service.call).to be false
      end
    end

    # context "when upgrading to an invalid role" do
    #   it "does not upgrade the role" do
    #     service = StudentsService.new(student, "random_role", "some_code", "new_password", "new_password")
    #     expect(service.call).to be false
    #     expect(student.reload.role).to eq("student") # Role should not change
    #   end
    # end
  end

  describe "#valid_role_upgrade?" do
    context "when role is admin and code is valid" do
      before do
        allow(AccessCode).to receive(:verify_admin_code).with("valid_code").and_return(true)
      end

      it "returns true" do
        service = StudentsService.new(student, "admin", "valid_code", "Password@123", "Password@123")
        expect(service.valid_role_upgrade?).to be true
      end
    end

    context "when role is club_head and code is valid" do
      before do
        allow(AccessCode).to receive(:verify_club_head_code).with("valid_code").and_return(true)
      end

      it "returns true" do
        service = StudentsService.new(student, "club_head", "valid_code", "Password@123", "Password@123")
        expect(service.valid_role_upgrade?).to be true
      end
    end

    context "when role is admin and code is invalid" do
      before do
        allow(AccessCode).to receive(:verify_admin_code).with("invalid_code").and_return(false)
      end

      it "returns false" do
        service = StudentsService.new(student, "admin", "invalid_code", "Password@123", "Password@123")
        expect(service.valid_role_upgrade?).to be false
      end
    end

    context "when role is club_head and code is invalid" do
      before do
        allow(AccessCode).to receive(:verify_club_head_code).with("invalid_code").and_return(false)
      end

      it "returns false" do
        service = StudentsService.new(student, "club_head", "invalid_code", "password", "password")
        expect(service.valid_role_upgrade?).to be false
      end
    end

    context "when role is invalid" do
      it "returns false" do
        service = StudentsService.new(student, "invalid_role", "some_code", "password", "password")
        expect(service.valid_role_upgrade?).to be false
      end
    end
  end

  describe "#upgrade_role" do
    it "updates the student's role and password" do
      service = StudentsService.new(student, "admin", "valid_code", "Password@123", "Password@123")
      service.upgrade_role
      expect(student.reload.role).to eq("admin")
      expect(student.authenticate("Password@123")).to be_truthy
    end
  end
end
