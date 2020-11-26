require "rails_helper"

RSpec.describe API::V1::BoundariesController, type: :controller do
  set_token

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns the names of the available boundaries" do
      get :index
      expect(response.body).to match(/Ocean/)
    end
  end
end
