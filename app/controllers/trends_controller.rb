class TrendsController < ApplicationController
  before_action :ensure_admin!

  def index
    @trends = Export::Trends.new.call
  end
end
