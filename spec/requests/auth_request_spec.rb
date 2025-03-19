require 'rails_helper'

RSpec.describe AuthController, type: :request do

  describe "POST /signup" do
    let(:student_params) do
      {
        student: {
          name: 'Cia',
          email: 'cia2@gmail.com',
          password: 'Cia@123',
          password_confirmation: 'Cia@123'
        }
      }
    end

    context "Creating a student" do
      it "returns http success status" do
        post '/signup', params: student_params
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)

      end


      it "returns unprocessable entity when any credentials are passed wrong" do
        student_params[:student][:email] = ""
        post '/signup', params: student_params
        
        expect(response.status).to eq(422)
      end
    end
    
  end


  describe "POST /login" do
    context "only for login " do
      let(:student) { FactoryBot.build(:student1) }
      
      

      it "returns http success status" do
        student_params = { email: student.email, password: student.password }
        post "/login", params: student_params
      
        expect(response.status).to redirect_to(root_path)
      end
      

      it "returns 401 code for invalid password" do
        student_params2 = { email: "", password: student.password }

        post '/login', params: student_params2
        expect(response.status).to eq(401)
      end
    end
  end

end