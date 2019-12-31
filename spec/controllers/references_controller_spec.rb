require "rails_helper"

RSpec.describe ReferencesController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let(:reference) { create :reference }
    it "returns http success" do
      get :show, params: {id: reference.id}
      expect(response).to have_http_status(:success)
    end
  end
end
