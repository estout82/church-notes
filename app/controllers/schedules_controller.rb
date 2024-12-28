# frozen_string_literal: true

class SchedulesController < ApplicationController
  before_action :require_login!
  before_action :set_schedule!, only: [:show, :edit, :update, :destroy]
  before_action :set_policy
  before_action :require_index_permission!, only: [:index]
  before_action :require_update_permission!, only: [:edit, :update]
  before_action :require_create_permission!, only: [:new, :create]
  before_action { @current_page = :schedules }

  def index
    @selected_date = if params[:selected_date].present?
      Date.parse(params[:selected_date]).change(day: 1)
    else
      DateTime.now.to_date.change(day: 1)
    end
  end

  def edit
    @schedule = Schedule.find(params[:id])
  end

  def update
    @schedule = Schedule.find(params[:id])

    start_at = Schedule::DateTimeAssembler.run(
      date_iso: schedule_params[:start_date],
      time_iso: schedule_params[:start_time]
    )

    end_at = Schedule::DateTimeAssembler.run(
      date_iso: schedule_params[:end_date],
      time_iso: schedule_params[:end_time]
    )

    if @schedule.update({
      note_id: schedule_params[:note_id],
      start_at: start_at.utc,
      end_at: end_at.utc
    })
      respond_to :turbo_stream
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @schedule = Schedule.new
    @modal_id = params[:modal_id]

    if params[:date]
      @schedule.start_at = DateTime.parse(params[:date])
      @schedule.end_at = DateTime.parse(params[:date]) + 12.hours
    end
  end

  def create
    start_at = Schedule::DateTimeAssembler.run(
      date_iso: schedule_params[:start_date],
      time_iso: schedule_params[:start_time]
    )

    end_at = Schedule::DateTimeAssembler.run(
      date_iso: schedule_params[:end_date],
      time_iso: schedule_params[:end_time]
    )

    @schedule = Schedule.new(
      note_id: schedule_params[:note_id],
      account_id: current_account.id,
      start_at: start_at.utc,
      end_at: end_at.utc
    )

    if @schedule.save
      @occurrences = Schedule::OccurrenceDecider.run(
        schedule: @schedule,
        timezone: current_user.time_zone
      )

      respond_to do |format|
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    unless @policy.can_update?
      toast(
        "You're not allowed to delete that schedule",
        path: schedules_path,
        status: :forbidden
      )

      return
    end

    if @schedule.destroy
      respond_to :turbo_stream
    else
      toast(
        "We weren't able to delete that schedule",
        path: schedules_path
      )
    end
  end

  private

  #
  # actions
  #

  def set_schedule!
    @schedule = Schedule.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
    flash[:error] = "We couldn't find that schedule"
  end

  def set_policy
    @policy = if @schedule.present?
      @schedule.policy user: current_user, account: current_account
    else
      SchedulePolicy.new current_user, current_account
    end
  end

  def require_index_permission!
    unless @policy.can_create?
      toast(
        "Sorry, you're not allowed to view the schedule for this account",
        status: :unauthorized,
        level: :error
      )
    end
  end

  def require_update_permission!
    unless @policy.can_update?
      toast(
        "Sorry, you're not allowed to edit the schedule for this account",
        status: :unauthorized,
        level: :error
      )
    end
  end

  def require_create_permission!
    unless @policy.can_create?
      toast(
        "Sorry, you're not allowed to schedule notes on this account",
        status: :unauthorized,
        level: :error
      )
    end
  end

  #
  # params
  #

  def schedule_params
    params.require(:schedule).permit(
      :note_id,
      :start_date,
      :start_time,
      :end_date,
      :end_time
    )
  end
end
