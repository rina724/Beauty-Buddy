class DailyReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_daily_report, only: [ :show, :edit, :update, :destroy ]

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

  def show
    @date = @daily_report.start_time
  end

  def edit
    @date = @daily_report.start_time
    @mycosmetids_for_daily_use = current_user.mycosmetics.for_daily_use
  end

  def update
    if @daily_report.update(daily_report_params)
      redirect_to daily_report_path(@daily_report), success: "デイリー入力を更新しました"
    else
      @date = @daily_report.start_time
      @mycosmetids_for_daily_use = current_user.mycosmetics.for_daily_use
      flash.now[:danger] = "デイリー入力の更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @daily_report.destroy!
    redirect_to daily_reports_path, success: "カレンダーから削除しました"
  end

  private

  def set_daily_report
    @daily_report = current_user.daily_reports.find(params[:id])
  end

  def daily_report_params
    params.require(:daily_report).permit(:start_time, :health, :memo,
      daily_report_cosmetics_attributes: [ :id, :mycosmetic_id, :_destroy ])
  end
end
