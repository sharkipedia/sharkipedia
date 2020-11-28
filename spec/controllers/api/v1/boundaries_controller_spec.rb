require "rails_helper"

RSpec.describe API::V1::BoundariesController, type: :controller do
  set_token
  let(:document) { JSON.parse(response.body) }

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

  describe "GET #show" do
    let!(:atlantic) { create :ocean, name: "Atlantic" }

    it "returns http success" do
      get :show, params: {name: "oceans"}
      expect(response).to have_http_status(:success)
    end

    it "returns the details of the selected boundary type" do
      get :show, params: {name: "oceans"}
      expect(response.body).to be_include(atlantic.name)
    end
  end
end
