require "rails_helper"

class TestAuthController < ApplicationController
  MESSAGE = "you should not see this"
  def index
    render plain: MESSAGE
  end
end

class OkController < PreAuthController
  MESSAGE = "you should be able to see this"
  def index
    render plain: MESSAGE
  end
end

RSpec.describe "Enforce authentication by default" do
  before do
    driven_by(:cuprite)

    Rails.application.routes.draw do
      resources :test_auth, only: :index
      resources :ok, only: :index
    end
  end

  after do
    Rails.application.reload_routes!
  end

  describe "Controller inheriting ApplicationController" do
    context "should not be publicly accessible" do
      before { get "/test_auth" }

      it { expect(response).to redirect_to("/") }
      it { expect(response.body).not_to have_text(TestAuthController::MESSAGE) }
    end

    context "should be accessible for users" do
      before do
        user = create(:user)
        sign_in user
        get "/test_auth"
      end

      it { expect(response).not_to redirect_to("/") }
      it { expect(response.body).to have_text(TestAuthController::MESSAGE) }
    end
  end

  describe "Controller inheriting PreAuthController" do
    it "should be publicly accessible" do
      get "/ok"

      expect(response).not_to redirect_to("/")
      expect(response.body).to have_text(OkController::MESSAGE)
    end
  end
end
