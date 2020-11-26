require "rails_helper"

RSpec.describe API::V1::SpeciesController, type: :controller do
  set_token
  let!(:species) { create :species }

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

  describe "POST #query" do
    context "when :geometry (geojson polygon)" do
      let!(:trend_species) { create :species }
      let!(:trait_species) { create :species }
      let!(:location) { create :location, name: "Hawaii", lat: 20, lon: -160 }
      let!(:trend) { create :trend, location: location, species: trend_species }
      let!(:reference) { create :reference }
      let!(:observation) { create :observation, species: trait_species, references: [reference] }
      let!(:measurement) { create :measurement, location: location, observation: observation }

      let!(:other_trend) { create :trend, species: species }
      let!(:other_reference) { create :reference }
      let!(:other_observation) { create :observation, species: species, references: [other_reference] }
      let!(:other_measurement) { create :measurement, observation: other_observation }

      let(:hawaii_geojson) { File.read("spec/fixtures/geo/hawaii.geojson") }
      let(:document) { JSON.parse(response.body)["data"] }

      it "should return the correct species" do
        post :query, params: {geometry: hawaii_geojson}

        expect(response.body).to match(/#{trend_species.name}/)
        expect(response.body).to match(/#{trait_species.name}/)
        expect(response.body).not_to match(/#{species.name}/)
      end
    end
  end
end
