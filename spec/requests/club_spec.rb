require 'rails_helper'

RSpec.describe "ClubsController", type: :request do
  let(:student) { FactoryBot.create(:student, email: "xyz@gmail.com") } 
  let(:other_student) { FactoryBot.create(:student, email: "dfsd2@gmail.com", role: "user") }
  let(:club) { FactoryBot.create(:club, student: student) }

  before do
    post login_path, params: { email: student.email, password: student.password }
    @student_cookie = response.cookies["student_id"]
  end

  describe "GET #index" do
    it "returns success and assigns clubs" do
      get "/clubs", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    context "when club exists" do
      it "returns success and assigns the club" do
        get "/clubs/#{club.id}", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response).to have_http_status(200)
      end
    end

    context "when club does not exist" do
      it "redirects with an error message" do
        get "/clubs/999", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response).to redirect_to(clubs_path)
        follow_redirect!
        expect(response.body).to include("Club not found.")
      end
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get "/clubs/new", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #edit" do
    context "when authorized" do
      it "renders the edit template" do
        get "/clubs/#{club.id}/edit", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response).to have_http_status(200)
      end
    end

    context "when unauthorized" do
      it "returns unauthorized status" do
        post login_path, params: { email: other_student.email, password: other_student.password }
        other_student_cookie = response.cookies["student_id"]
    
        get "/clubs/#{club.id}/edit", headers: { 'Cookie' => "student_id=#{other_student_cookie}" }
        expect(response).to redirect_to(login_path)
      end
    end
    
  end

  describe "POST #create" do
    let(:club) { FactoryBot.build(:club1) }

    club_params = {
      club: {
        club_name: "CODE GEEKS",
        club_logo: Rails.root.join('images', 'ER_Events.png').open, 
        student_id: Student.first.id
      }
    }

    context "with valid attributes" do
      it "creates a new club and redirects" do
        post "/clubs", params: club_params, headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response.status).to eq(302)
      end
    end

    context "with invalid attributes" do
      it "renders new template" do
        post "/clubs", params: { club: { club_name: "" } }, headers: { 'Cookie' => "student_id=#{@student_cookie}" }
          expect(response.status).to eq(422)
              
      end
    end

  end

  describe "PATCH #update" do
    let(:student) { FactoryBot.create(:student, email: "mno2@gmail.com") } 

    context "when authorized" do
      it "updates the club and redirects" do
        patch "/clubs/#{club.id}", params: { club: { club_name: "Updated Club" } }, headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response).to redirect_to(club)
        follow_redirect!
        expect(response.body).to include("Club was successfully updated.")
        expect(club.reload.club_name).to eq("Updated Club")
      end
    end

    context "with invalid attributes" do
      it "renders the edit template" do
        patch "/clubs/#{club.id}", params: { club: { club_name: "" } }, headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE #destroy" do
  
  
    let(:student) { FactoryBot.create(:student, email: "ergfd234@gmail.com", role: "club_head") } 
    context "when authorized" do

      it "deletes the club and redirects" do
        club
        expect {
          delete "/clubs/#{club.id}", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        }.to change(Club, :count).by(-1)

        expect(response).to redirect_to(clubs_path)
        follow_redirect!
        expect(response.body).to include("Club was successfully deleted.")
      end
    end

    context "when unauthorized" do
      it "returns unauthorized status" do
        student.role = "user"

        delete "/clubs/#{club.id}", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET #my_club" do
    it "renders my_club template" do
      get "/my_club", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
      expect(response).to have_http_status(302)
    end
  end

  describe "GET #welcome" do
    it "renders the welcome page" do
      get "/welcome"
      expect(response).to have_http_status(302)
    end
  end
end
