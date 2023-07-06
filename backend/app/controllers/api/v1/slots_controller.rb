class Api::V1::SlotsController < ApplicationController
  def booked_slots
    booked_slots = Slot.where(start_time: params[:start_time]...params[:end_time])

    render json: booked_slots
  end

  def create
    # TODO: should i add more validation for start/end time
    slot = Slot.new(
      start_time: params[:start_time],
      end_time: params[:end_time]
    )

    if slot.save
      render json: slot, status: :ok
    else
      render json: slot.errors.messages, status: :bad_request
    end
  end

  def search
    date = slot_params[:date]
    duration = slot_params[:duration]
    timezone = slot_params[:timezone]

    # debugger
    # TODO: validate timezone

    # TODO: set default max duration and return best response here

    if !validate_timezone(timezone)
      render json: { error: "Invalid timezone" }, status: :bad_request
      return
    end

    duration = validate_time(duration)

    if !duration
      render json: { error: "Invalid duration" }, status: :bad_request
      return
    end

    date = validate_date(date)

    # debugger
    if !date || date < Date.current
      render json: { error: "Invalid date" }, status: :bad_request
      return
    end

    available_slots = AvailableSlots.new(date, duration, timezone).get_available_slots

    render json: available_slots, status: :ok
  end

  private

  def slot_params
    params.permit(:duration, :date, :start_time, :end_time, :timezone)
  end

  def validate_timezone(timezone)
    return false if !timezone

    TZInfo::Timezone.all_identifiers.include? timezone
  end

  def validate_time(duration)
    duration = ChronicDuration::parse(duration)

    return false if !duration || duration > 10.hours || duration < 10.minutes

    duration.seconds
  rescue ChronicDuration::DurationParseError
    return false
  end

  def validate_date(date)
    Date.parse(date)
  rescue Date::Error
    false
  end
end