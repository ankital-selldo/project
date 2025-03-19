require 'rails_helper'

RSpec.describe "Password Reset", type: :request do


  context "GET requests for password reset" do

    it "should show interface for resetting password" do
      get "/password/reset"
      expect(response.status).to eq(200)
    end

    # it "should" do

    #   get '/password/reset/edit'
    #   binding.pry
    #   expect(response.status).to eq(200)
    # end
  end

  context "POST for password reset" do
    let(:student) { FactoryBot.build(:student1) }
    it "should show interface for resetting password" do

      get "/password/reset"
      expect(response.status).to eq(200)
    end

    it "should" do
      post "/password/reset"
      expect(response.status).to eq(200)
    end

    it "must be a invalid request" do
      post "/password/reset"
      expect(response.status).to eq(200)
    end
  end
end