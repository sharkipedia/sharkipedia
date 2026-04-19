require "rails_helper"

RSpec.describe "Admin dashboards", type: :request do
  describe "GET /admin/users" do
    context "as an admin" do
      before { sign_in create(:admin), scope: :user }

      it "returns http success" do
        get "/admin/users"
        expect(response).to have_http_status(:success)
      end
    end

    context "as an editor" do
      before { sign_in create(:editor), scope: :user }

      it "returns http success" do
        get "/admin/users"
        expect(response).to have_http_status(:success)
      end
    end

    context "as a plain user" do
      before { sign_in create(:user), scope: :user }

      it "redirects to root" do
        get "/admin/users"
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
