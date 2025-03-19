require 'rails_helper'


RSpec.describe Event, type: :request do

  describe "For fetching events" do
    let(:student) { FactoryBot.build(:student1) }
    context "Checking validity for reading events" do

      before do
        #login
        post login_path, params: { email: student.email, password: student.password }
        @student_cookie = response.cookies["student_id"]
      end

      it "only for getting index of events" do

        get '/events', headers: { 'Cookie' => "student_id=#{@student_cookie}"}
        expect(response).to have_http_status(200)
      end

      it "only for getting index of events" do

        get '/events', headers: { 'Cookie' => "student_id=#{@student_cookie}"}
        expect(response).to have_http_status(200)
      end
    end

    # let(:event) { FactoryBot.build(:event) }
    # # let(:student) { FactoryBot.build(:student2, role: "user") }
    # context "Creating a new event" do

    #   before do
    #     #login
    #     post login_path, params: { email: student.email, password: student.password }
    #     @student_cookie = response.cookies["student_id"]
    #   end

    #   it "with role as club_head" do

    #     post "/events", params: { event: event }
    #     expect(response.status).to redirect_to(root_path)

    #   end

    #   # it "with role as club_head" do
    #   #   post "/events", params: { event: event }
    #   #   expect(response.status).to eq(302)

    #   # end
    # end
  end


  # describe "For editing events" do

  #   let!(:student) { FactoryBot.build(:student1) }
  #   let!(:event) { FactoryBot.build(:event) }
  #   context "when having different roles" do
      
  #     before do
  #       #login
  #       post login_path, params: { email: student.email, password: student.password }
  #       @student_cookie = response.cookies["student_id"]
  #     end

  #     it "must be a valid/invaid request depending upon role for editing events" do
  #       # let!(:event) { (:event, event_title: "Tech Conference") }
  #       binding.pry
  #       event.event_name = "Tech Conference"
  #       post edit_event_path
  #       # except(json[event_name]).to eq("10:30:00")
  #       except(response.status).to eq(302)

  #     end
  #   end

  # end
end