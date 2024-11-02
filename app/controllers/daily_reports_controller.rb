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
      redirect_to daily_reports_path, success: t("defaults.flash_message.created", item: DailyReport.model_name.human)
    else
      @date = @daily_report.start_time
      @mycosmetids_for_daily_use = current_user.mycosmetics.for_daily_use
      flash.now[:danger] = t("defaults.flash_message.alreadly_registered")
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
      redirect_to daily_report_path(@daily_report), success: t("defaults.flash_message.updated", item: DailyReport.model_name.human)
    else
      @date = @daily_report.start_time
      @mycosmetids_for_daily_use = current_user.mycosmetics.for_daily_use
      flash.now[:danger] = t("defaults.flash_message.not_updated", item: DailyReport.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @daily_report.destroy!
    redirect_to daily_reports_path, success: t("defaults.flash_message.destroyed", item: DailyReport.model_name.human)
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
