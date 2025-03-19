require 'rails_helper'

RSpec.describe Register, type: :request do

  describe "For fetching registerations" do
    let(:student) { FactoryBot.build(:student1) }
    context "Registering for an event" do

      before do
        #login
        post login_path, params: { email: student.email, password: student.password }
        @student_cookie = response.cookies["student_id"]
      end

      it "only for getting index of events" do

        get '/registers', headers: { 'Cookie' => "student_id=#{@student_cookie}"}
        expect(response).to have_http_status(200)
      end
    end

  end

end