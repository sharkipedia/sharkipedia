require "rails_helper"

RSpec.describe DataExportController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    describe "export" do
      let(:measurement) { create(:measurement) }
      let(:slug) { measurement.observation.species.first.slug }

      it "returns http success" do
        get :index, params: {commit: "true", export_type: "Traits", species: [slug]}
        expect(response).to have_http_status(:success)
      end
    end
  end
end
