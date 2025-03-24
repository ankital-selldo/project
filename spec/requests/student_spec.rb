# require 'rails_helper'


# RSpec.describe Student, type: :request do
#   describe "GET /students" do 
    
#     let(:student) { FactoryBot.build(:student1) }
#     context "Creating a student" do

#       before do
#         #login
#         post login_path, params: { email: student.email, password: student.password }
#         @student_cookie = response.cookies["student_id"]
#       end

#       it "only for getting crud of students" do

#         get '/students', headers: { 'Cookie' => "student_id=#{@student_cookie}"}
#         expect(response).to have_http_status(302)
#       end
#     end

#   end
# end

require 'rails_helper'

RSpec.describe "Students", type: :request do
  let!(:student) { FactoryBot.create(:student4) }
  let!(:admin) {  FactoryBot.create(:student4, role: "admin") }

  before do
    #login
    post login_path, params: { email: student.email, password: student.password }
    @student_cookie = response.cookies["student_id"]
  end

  describe "GET /students" do
    context "when logged in" do

      it "returns http success" do
        get "/students", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response).to have_http_status(302)
      end

    end

    context "when not logged in" do
      before { get students_path }

      it "redirects to login page" do
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe "GET /students/new" do
  
    it "returns http success" do
      get "/students/new", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
      expect(response).to have_http_status(302)
    end
  end

  describe "POST /students" do
    context "with valid parameters" do
      let(:valid_params) { { name: "John Doe", email: "john@example.com", password: "Password@123", role: "user" } }

      it "creates a new student" do
        expect {
          post students_path, params: valid_params
        }.to change(Student, :count).by(1)
      end

      it "redirects to students_path" do
        post students_path, params: valid_params
        expect(response).to redirect_to(students_path)
      end
    end

  end

  describe "GET /students/:id" do
  
    it "returns http success" do
      get "/students/#{student.id}", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
      expect(response).to have_http_status(302)
    end
  end

  describe "PATCH /students/:id" do
    let(:update_params) { { name: "Updated Name" } }

   

    # it "updates the student" do
    #   patch student_path(student), params: update_params
    #   student.reload
    #   expect(response.status).to eq(302)
    # end
  end

  describe "GET /role_upgrade" do

    it "renders the role upgrade page" do
      get '/role_upgrade', headers: { 'Cookie' => "student_id=#{@student_cookie}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /verify_role_code" do
    let(:valid_params) { { role_type: "admin", code: "VALID_CODE", password: "newpass", confirm_password: "newpass" } }

    it "upgrades the student's role" do
      valid_params[:code] = "ADMIN_SECRET_2025"
      post verify_role_code_path, params: valid_params
      expect(response.status).to eq(302)
      expect(flash[:alert]).to eq("You've been upgraded to admin role.")
    end

    context "when the code is invalid" do

      it "redirects back to role upgrade page with error" do
        expect(response.status).to eq(302)
      end
    end
  end
end
