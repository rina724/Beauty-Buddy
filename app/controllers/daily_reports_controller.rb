class DailyReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @daily_report = DailyReport.all
  end

  def new
    @daily_report = DailyReport.new
    @date = params[:date].to_date
    @mycosmetids_for_daily_use = current_user.mycosmetics.for_daily_use
  end

  def create

  end
end
