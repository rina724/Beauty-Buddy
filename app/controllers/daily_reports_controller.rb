class DailyReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @daily_reports = DailyReport.includes(:user).where(user: current_user)
  end

  def new
    @daily_report = DailyReport.new
    @date = params[:date].to_date
    @mycosmetids_for_daily_use = current_user.mycosmetics.for_daily_use
  end

  def create
    @daily_report = current_user.daily_reports.build(daily_report_params)
    if @daily_report.save
        redirect_to daily_reports_path, success: "デイリー入力が完了しました"
    else
      @date = @daily_report.start_time
      @mycosmetids_for_daily_use = current_user.mycosmetics.for_daily_use
      flash.now[:danger] = "すでに登録されています"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def daily_report_params
    params.require(:daily_report).permit(:start_time, :health, :memo,  daily_report_cosmetics_attributes: [:mycosmetic_id])
  end
end
