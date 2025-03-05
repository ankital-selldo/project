require 'rails_helper'


RSpec.describe Student, type: :request do

  
  describe "GET /students" do 
    let(:student) { create :student }

    context "Students for all CRUD" do


      it "only for getting crud of students" do

        get '/students'
        expect(response).to redirect_to(students_path)
      end
    end
  end
end