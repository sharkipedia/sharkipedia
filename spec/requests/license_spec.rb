require "rails_helper"

RSpec.describe "License notice", type: :request do
  it "explains CC BY-NC 4.0 on the About page" do
    get "/about"

    expect(response.body).to include(%(id="license"))
    expect(response.body).to include("https://creativecommons.org/licenses/by-nc/4.0/")
  end
end
