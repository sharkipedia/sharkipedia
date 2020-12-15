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
    let(:asm) { Eez.find_by iso_ter1: "ASM" }

    it "returns http success" do
      get :show, params: {name: "oceans"}
      expect(response).to have_http_status(:success)
    end

    context "when oceans" do
      it "returns the details all available oceans" do
        get :show, params: {name: "oceans"}
        expect(response.body).to be_include(atlantic.name)
      end
    end

    context "when EEZ" do
      it "returns the details all available EEZs" do
        get :show, params: {name: "eez"}
        expect(response.body).to be_include(asm.geoname)
      end
    end
  end
end
