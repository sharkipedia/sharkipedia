require "rails_helper"

RSpec.describe "sharkipedia.org", type: :request do
  it "redirects to www, keeping the path and query" do
    host! "sharkipedia.org"
    get "/species?page=2"

    expect(response).to have_http_status(:moved_permanently)
    expect(response).to redirect_to("https://www.sharkipedia.org/species?page=2")
  end

  it "leaves other hosts alone" do
    host! "www.sharkipedia.org"
    get "/up"

    expect(response).to have_http_status(:ok)
  end
end
