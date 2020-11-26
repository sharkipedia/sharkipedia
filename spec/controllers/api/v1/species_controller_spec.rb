require "rails_helper"

RSpec.describe API::V1::SpeciesController, type: :controller do
  set_token
  let!(:species) { create :species }
  let(:document) { JSON.parse(response.body) }

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
    context "when :ocean given" do
      let!(:trend_species) { create :species }
      let!(:trend) { create :trend, species: trend_species }

      it "should return the correct species" do
        post :query, params: {oceans: trend.oceans.map(&:name)}

        expect(response.body).to match(/#{trend_species.name}/)
        expect(response.body).not_to match(/#{species.name}/)
      end

      context "when invalid ocean name" do
        it "should return nothing" do
          post :query, params: {oceans: ["hi-mom"]}

          expect(document["meta"]["total"]).to eq(0)
        end
      end
    end

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

      it "should return the correct species" do
        post :query, params: {geometry: hawaii_geojson}

        expect(response.body).to match(/#{trend_species.name}/)
        expect(response.body).to match(/#{trait_species.name}/)
        expect(response.body).not_to match(/#{species.name}/)
      end

      context "when no query given" do
        it "should return the nothing" do
          post :query, params: {geometry: {}}

          expect(document["meta"]["total"]).to eq(0)
        end
      end
    end
  end
end
