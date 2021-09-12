require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:imports) }
    it { should have_many(:observations) }
    it { should have_many(:trends) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "#send_devise_notification" do
    let(:user) do
      User.create!(name: "Test User", email: "test@example.com",
        password: "123456789")
    end

    before { ActiveJob::Base.queue_adapter = :test }
    after { ActiveJob::Base.queue_adapter = :sidekiq }

    it do
      expect { user }.to have_enqueued_mail(Devise::Mailer, :confirmation_instructions)
    end
  end

  describe "token assignment" do
    let(:user) do
      User.new(name: "Test User", email: "test@example.com", password: "123456789")
    end

    it "is expected to assign a token" do
      expect { user.save }.to change { user.token }
    end
  end
end
