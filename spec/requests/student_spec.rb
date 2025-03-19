require 'rails_helper'


RSpec.describe Student, type: :request do
  describe "GET /students" do 
    
    let(:student) { FactoryBot.build(:student1) }
    context "Creating a student" do

      before do
        #login
        post login_path, params: { email: student.email, password: student.password }
        @student_cookie = response.cookies["student_id"]
      end

      it "only for getting crud of students" do

        get '/students', headers: { 'Cookie' => "student_id=#{@student_cookie}"}
        expect(response).to have_http_status(200)
      end
    end

  end
end