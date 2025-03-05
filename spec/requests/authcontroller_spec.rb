require 'rails_helper'

RSpec.describe AuthController, type: :request do

  describe "POST /signup" do
    let(:student_params) do
      {
        student: {
          name: 'Jia',
          email: 'jia2@gmail.com',
          password: 'Jia@123',
          password_confirmation: 'Jia@123'
        }
      }
    end

    context "Creating a student" do
      it "returns http success status" do
        post '/signup', params: student_params
        
        # expect(response.status).to eq(302)
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
    let!(:student) { create(:student, name: 'Ria', email: 'ria2@gmail.com', password: 'Ria@123', password_confirmation: 'Ria@123') }


    
    context "only for login " do
      let(:student_params) do
        {
          student: {
            email: 'ria2@gmail.com',
            password: 'Ria@123'
          }
        }
      end

      let(:student_params2) do
        {
          student: {
            email: '',
            password: '123'
          }
        }
      end

      it "returns http success status" do
        post '/login', params: student_params
        
        expect(response.status).to redirect_to(root_path)
      end
      

      it "returns 401 code for invalid password" do

        post '/login', params: student_params2
        # binding.pry
        expect(response.status).to eq(401)
      end
    end
  end

end