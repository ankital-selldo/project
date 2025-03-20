require 'rails_helper'


RSpec.describe Event, type: :request do

  let(:student) { FactoryBot.build(:student1) }

  before do
    #login
    post login_path, params: { email: student.email, password: student.password }

    @student_cookie = response.cookies["student_id"]
  end

  describe "GET /events" do
    context "Checking validity for reading events" do

      it "only for getting index of events" do

        get '/events', headers: { 'Cookie' => "student_id=#{@student_cookie}"}
        expect(response).to have_http_status(200)
      end

      it "only for getting index of events" do

        get '/events', headers: { 'Cookie' => "student_id=#{@student_cookie}"}
        expect(response).to have_http_status(200)
      end
    end
  
  end

  describe "GET /events/:id" do

    context "GET /events/:id" do
      let(:event) { FactoryBot.build(:event) }

      it "GET /events/:id with event existing" do

        get "/events/#{event.id}", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response.status).to eq(200) 
      end


      it "GET /events/:id with event non-existing" do

        get "/events/1000", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response).to have_http_status(404) 
        expect(response.message).to include("Not Found") 

      end
    end

  end

  describe "POST /events" do
    event_params = {
      event: {
        event_name: "New Test Event",
        event_desc: "This is a test event",
        event_venue: "Test Venue",
        event_time: "12:00",
        event_date: Date.today,
        event_deadline: Date.today + 2.days,
        club_id: Club.first.id
      }
    }

    # let(:event) { FactoryBot.create(:event) }
    context "Creating events " do

      it "will create a event if role is club_head" do
        student.role = "club_head"
        post "/events", params: event_params 
        expect(response).to have_http_status(302) #show_event_path

      end

      it "will create a event if role is user" do
        student.role = "user"
        post "/events", params: event_params 
        expect(response).to redirect_to(root_path) #root_path for unauthorized action
      end

    end
  end

  describe "PUT /events/:id" do

    context "Updating events" do

      

    end
  end
end