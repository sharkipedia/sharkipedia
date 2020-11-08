module ApiMacros
  def set_token
    before(:each) do
      user = FactoryBot.create(:user)
      user.confirm
      @request.headers["Authorization"] = "Token #{user.token}"
      sign_in user
    end
  end
end

RSpec.configure do |config|
  config.extend ApiMacros, type: :controller
end
