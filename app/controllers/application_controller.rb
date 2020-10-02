class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper, AttendanceConfirmationHelper

  $days_of_the_week = %w{日 月 火 水 木 金 土}
  $alphabet = [*'a'..'z']

  # paramsハッシュからユーザーを取得する。
  def set_user
    @user = User.find(params[:id])
  end

  # ページ出力前に1ヶ月分のデータの存在を確認・セットする。
  def set_one_month
    if params[:readonly_flag] == "1"
      @first_day = params[:date].to_date
      @last_day = @first_day.end_of_month
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    else
      set_one_month_default
    end
  end
  
  # 上長選択のプルダウン用
  def set_superiors
    @superiors = User.where(superior: true)
  end
end
