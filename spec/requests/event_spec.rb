require 'rails_helper'

RSpec.describe Event, type: :request do

  let(:student) { FactoryBot.build(:student1) }
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

  describe "GET /events/new" do
    it "renders the new event form for club_head" do
      student.role = "club_head"
      get "/events/new", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
      expect(response).to have_http_status(302)
    end
  end
  
  describe "GET /events/:id/edit" do
    let(:event) { FactoryBot.create(:event) }
  
    it "allows club_head to edit an event" do
      student.role = "club_head"
      get "/events/#{event.id}/edit", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
      expect(response).to have_http_status(302)
    end
  
    it "denies edit access to regular users" do
      student.role = "user"
      get "/events/#{event.id}/edit", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
      expect(response).to redirect_to(root_path)
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
        expect(response).to have_http_status(302) 

      end
    end

  end

  describe "POST /events" do
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
      
      
      it "fails to create an event with missing name" do
        student.role = "club_head"
        invalid_params = event_params.deep_merge(event: { event_name: "" })
        
        post "/events", params: invalid_params, headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        
        expect(response).to have_http_status(302) # 422
        # expect(response.body).to include("Event name can't be blank")
      end
      
    end


    
  end

  describe "PUT /events/:id" do
    let(:event) { FactoryBot.create(:event) }
    
    context "Updating events based on role" do

      it "will update event if role is club_head" do
        student.role = "club_head"
        put "/events/#{event.id}", params: { event: { event_desc: "EFIUGDNBFRUEDW FRGEUIWDHKJBHFRYRIEDJF" } }
        expect(response).to redirect_to(root_path)
      end

      it "will update event if role is user" do
        student.role = "user"
        put "/events/#{event.id}", params: { event: { event_desc: "EFIUGDNBFRUEDW FRGEUIWDHKJBHFRYRIEDJF" } }
        # expect(response.status).to eq(422)
        expect(response).to redirect_to(root_path)

      end
    
      it "will update event if role is admin" do
        student.role = "admin"
        put "/events/#{event.id}", params: { event: { event_desc: "EFIUGDNBFRUEDW FRGEUIWDHKJBHFRYRIEDJF" } }
        expect(response.status).to eq(302)

      end

    end
  end

  describe "DELETE /events/:id" do

    let(:event) { FactoryBot.create(:event) }
    
    context "Deleting events based on role" do

      it "will delete event if role is club_head" do
        student.role = "club_head"
        delete "/events/#{event.id}", params: { event: event }
        expect(response.status).to eq(302)
        binding.pry
        # expect(response).to redirect_to(events_path)
      end

      it "will delete event if role is user" do
        student.role = "user"
        delete "/events/#{event.id}", params: { event: event }
        expect(response.status).to eq(302)
        # expect(response).to redirect_to(root_path)

      end
    
      it "will delete event if role is admin" do
        student.role = "admin"
        delete "/events/#{event.id}", params: { event: event }
        expect(response.status).to eq(302)

      end

    end

  end

  describe "GET /events/:id/registrations" do
    let(:event) { FactoryBot.create(:event) }
    let(:student) { FactoryBot.create(:student1, email: "jon2@gmail.com", password: "Jon@123") }

    let!(:registration) { FactoryBot.create(:register, event: event, student: student) }
  
    context "accessing registerations based on role" do
      it "allows club_head to view event registrations" do
        student.role = "club_head"
        get "/events/#{event.id}/registrations", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response).to have_http_status(302)
      end
    
      it "denies access for non-club_head users" do
        student.role = "user"
        get "/events/#{event.id}/registrations", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response).to redirect_to(root_path)
      end
    end

  end
  

end