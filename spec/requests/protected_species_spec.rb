require 'rails_helper'

RSpec.describe "ProtectedSpecies", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/protected_species/index"
      expect(response).to have_http_status(:success)
    end
  end

end
