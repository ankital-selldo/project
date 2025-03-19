require 'rails_helper'

RSpec.describe Club, type: :request do

  describe "For fetching clubs" do
    let(:student) { FactoryBot.build(:student1, role: "club_head") }
    let(:club) { FactoryBot.build(:club1) }

    context "Checking authority" do
      before do
        #login
        post login_path, params: { email: student.email, password: student.password }
        @student_cookie = response.cookies["student_id"]
      end

      it "only for getting index of events" do

        get '/clubs', headers: { 'Cookie' => "student_id=#{@student_cookie}"}
        expect(response).to have_http_status(200)
      end
    end

    context "Create a club" do
      
      before do
        #login
        post login_path, params: { email: student.email, password: student.password }
        @student_cookie = response.cookies["student_id"]
      end

      it "with role as club_head" do
        post "/clubs", params: {club: { club_name: club.club_name, club_logo: club.club_logo }}
        expect(response.status).to eq(302)

      end

     
    end
  end

end