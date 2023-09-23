require "rails_helper"

RSpec.describe TraitsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let(:trait) { create :trait }
    it "returns http success" do
      get :show, params: {id: trait.id}
      expect(response).to have_http_status(:success)
    end
  end
end
