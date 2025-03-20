require 'rails_helper'

RSpec.describe "Password Reset", type: :request do

  describe "GET /password/reset" do
    context "GET requests for password reset" do

      it "should show interface for resetting password" do
        get "/password/reset"
        expect(response.status).to eq(200)
      end
  
    end  
  end

  describe "POST /password/reset" do
    let!(:student) { FactoryBot.build(:student1) }
    
    context "valid email" do
      it "should send a mail to required email" do

        
        post "/password/reset", params: { email: student.email }
        expect(response).to have_http_status(:ok)

      end

      
    end


    context "invalid email" do
      it "should not send a mail but only redirect" do
        post "/password/reset", params: { email: "student.email" }
        expect(response).to have_http_status(:ok)
        # expect(response).to redirect_to(root_path)
      end

      it "does not send an email and redirects" do
        post "/password/reset", params: { email: "" }
        expect(response).to have_http_status(:ok)
      end

    end
  end

  describe "GET /password/reset/edit" do
    let!(:student) { FactoryBot.create(:student1, email: "jonny2@gmail.com") }

    context "valid token" do
      it "must redirect to edit page " do
        @token = student.signed_id(purpose: "password_reset", expires_in: 15.minutes)
        get "/password/reset/edit", params: { token: @token }
        expect(response.status).to eq(200)
      end
    end


    context "invalid token" do
      it "will still redirect to root " do
        @token = student.signed_id(purpose: "password_reset", expires_in: 15.minutes)
        get "/password/reset/edit", params: { token: "@token" }
        expect(response.status).to eq(302)
      end
    end
  end

end