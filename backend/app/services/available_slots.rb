# frozen_string_literal: true

class AvailableSlots
  def initialize(date, duration, timezone)
    @date = Date.parse(date)
    @duration = ChronicDuration.parse(duration)
    @timezone = timezone
  end

  def get_available_slots
    start_time = get_start_time
    end_time = start_time.end_of_day

    slots = []

    while start_time < end_time
      current_end_time = start_time + @duration

      unless overlaps_with_booked_slots?(start_time, current_end_time)
        slots << {
          start_time:,
          end_time: current_end_time
        }
      end

      start_time += 15.minutes
    end

    slots
  end

  private

  def get_start_time
    current_time = Time.current.in_time_zone(@timezone)
    next_start_time = time_to_next_quarter_hour(current_time)

    [@date.in_time_zone(@timezone).beginning_of_day, next_start_time].max
  end

  def time_to_next_quarter_hour(time)
    quarter = (time.min % 15).zero? ? (time.min / 15) : (time.min / 15 + 1)
    next_quarter_hour = Time.new(time.year, time.month, time.day, time.hour, (quarter * 15) % 60)
    next_quarter_hour += 1.hour if quarter == 4

    next_quarter_hour
  end

  def overlaps_with_booked_slots?(start_time, end_time)
    # TODO: validate that calling the database here is best way
    sql = ':end_time > start_time and end_time > :start_time'

    Slot.where(sql, start_time:, end_time:).exists?
  end
end
