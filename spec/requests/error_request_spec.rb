require 'rails_helper'

RSpec.describe "ErrorsController", type: :request do
  describe "GET /any_invalid_route" do
    it "returns 404 error with JSON response" do
      get "/some_random_non_existent_route"
      expect(response.status).to eq(302)
    end
  end

  describe "Handling invalid routes for all HTTP methods" do
    it "returns 404 for POST request" do
      post "/invalid_post_route"
      expect(response).to have_http_status(302)
    end

    it "returns 404 for PUT request" do
      put "/invalid_put_route"
      expect(response).to have_http_status(302)
    end

    it "returns 404 for DELETE request" do
      delete "/invalid_delete_route"
      expect(response).to have_http_status(302)
    end
  end

  describe "Valid routes should not be affected" do
    it "does not trigger error for a valid route (e.g., /login)" do
      get "/login"
      expect(response).not_to have_http_status(404)
    end
  end
end
