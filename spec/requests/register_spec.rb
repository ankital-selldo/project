require 'rails_helper'

RSpec.describe Register, type: :request do
  let(:student) { FactoryBot.create(:student3) }
  
  before do
    #login
    post login_path, params: { email: student.email, password: student.password }
    @student_cookie = response.cookies["student_id"]
  end

  describe "GET /registerations" do

    context "Registering for an event" do
      it "lists registered events for current student when role is user" do

        get '/registers', headers: { 'Cookie' => "student_id=#{@student_cookie}"}
        expect(response).to have_http_status(200)
      end
    end

  end

  describe "GET /registerations/new" do

    context "Get #new" do
      it "redirects to root page showing page not found" do
        get "/registers/new", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response.status).to eq(302)
      end
    end

  end

  describe "GET /registerations/:id/edit" do
  
    it "redirects to root page showing page not found" do
      student.role = "club_head"
      get "/registers/#{student.id}/edit", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
      expect(response).to have_http_status(302)
    end
  end

  describe "GET /registerations/:id" do

    context "GET /registers/:id" do

      it "GET /registers/:id" do

        get "/registers/#{student.id}", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response.status).to eq(302) 
      end


      it "GET /registers/:id invalid id" do

        get "/registers/1000", headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response).to have_http_status(302) 

      end
    end

  end

  describe "POST /registers" do

    context "Registering for an event " do
     
      it "will redirect to root page when successfully registered" do
        event = FactoryBot.create(:event) 

        register_params = {
          register: {
            event_id: event.id, 
            name: student.name, 
            branch: "Comp", 
            year: "FE"
          }
        }
        post "/registers",  params: register_params, headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response).to have_http_status(302) #root page
      end

    end


    
  end

  describe "PUT /registers/:id" do
    event = FactoryBot.create(:event) 

    
    context "Updating the page registers by id" do

      it "will redirect the page since it is not needed" do
        event = FactoryBot.create(:event) 

        register_params = {
          register: {
            event_id: event.id, 
            name: student.name, 
            branch: "Comp", 
            year: "FE"
          }
        }
        put "/registers/99/edit", params: register_params, headers: { 'Cookie' => "student_id=#{@student_cookie}" }

        expect(response).to redirect_to(root_path)
      end

    end
  end

  describe "DELETE /registers/:id" do

    event = FactoryBot.create(:event) 
    student = FactoryBot.build(:student4)

    register_params = {
      register: {
        event_id: event.id, 
        name: student.name, 
        branch: "Comp", 
        year: "FE"
      }
    }    
    context "#registers/:id" do

      it "it will redirect to root" do
        delete "/registers/#{event.id}", params: register_params, headers: { 'Cookie' => "student_id=#{@student_cookie}" }
        expect(response.status).to eq(404)
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