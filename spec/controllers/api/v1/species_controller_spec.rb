require "rails_helper"

RSpec.describe API::V1::SpeciesController, type: :controller do
  set_token
  let(:species) { create(:species) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: {id: species.id}
      expect(response).to have_http_status(:success)
    end
  end
end
