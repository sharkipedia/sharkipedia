class TrendsController < ApplicationController
  def index
    @trends = Export::Trends.new.call
  end
end
