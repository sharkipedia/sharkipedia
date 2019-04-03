class TrendsController < ApplicationController
  def index
    @trends = Export::Trends.new.call

    respond_to do |format|
      format.html
      format.csv { send_data @trends, filename: "trends-#{Date.today}.csv" }
    end
  end
end
