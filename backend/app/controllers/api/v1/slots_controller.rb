class Api::V1::SlotsController < ApplicationController
  before_action :validate_slot_params, only: :search

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
    available_slots = AvailableSlots.new(
      slot_params[:date], slot_params[:duration], slot_params[:timezone]
    ).get_available_slots

    render json: available_slots, status: :ok
  end

  private

  def slot_params
    params.permit(:duration, :date, :start_time, :end_time, :timezone)
  end

  def validate_slot_params
    validator = SlotParamsValidator.new(slot_params)

    return if validator.valid?

    render json: { errors: validator.errors }, status: :bad_request
  end
end
