class Slot < ApplicationRecord
  DEFAULT_MAX_DURATION = 10.hours
  DEFAULT_MIN_DURATION = 10.minutes

  before_create :assign_uuid
  validate :valid_slot_times?
  validate :other_slot_overlap?
  validate :valid_duration?
  validate :start_is_multiple_of_15_minutes?
  validate :end_is_multiple_of_5_minutes?
  # TODO: load validators from another file and include them here
  # TODO: validate that slot minimum is 10 minutes

  validates :start_time, presence: true
  validates :end_time, presence: true

  def start_is_multiple_of_15_minutes?
    return unless start_time?

    return if multiple_of_15(start_time)

    errors.add(:start_time, 'should be a multiple of 15 minutes')
  end

  def end_is_multiple_of_5_minutes?
    return unless end_time?

    return if multiple_of_5(end_time)

    errors.add(:end_time, 'should be a multiple of 5 minutes')
  end

  def valid_slot_times?
    return unless start_time? && end_time?

    return if end_time.after?(start_time)

    errors.add(:start_time, 'must be before End Time')
    errors.add(:end_time, ' must be after Start Time')
  end

  def valid_duration?
    return unless start_time? && end_time?

    duration = end_time - start_time

    return unless duration < DEFAULT_MIN_DURATION || duration > DEFAULT_MAX_DURATION

    errors.add(:base, "Duration must be between #{DEFAULT_MIN_DURATION} minutes and #{DEFAULT_MAX_DURATION} hours")
  end

  def other_slot_overlap?
    sql = ':end_time > start_time and end_time > :start_time'

    is_overlapping = Slot.where(sql, start_time:, end_time:).exists?

    return unless is_overlapping

    errors.add(:base, 'Slot overlaps with other slots')
  end

  def assign_uuid
    self.id = SecureRandom.uuid
  end

  private

  # TODO: move this code somewhere?
  def multiple_of_15(time)
    minutes = time.strftime('%M').to_i

    minutes % 15 == 0
  end

  def multiple_of_5(time)
    minutes = time.strftime('%M').to_i

    minutes % 5 == 0
  end
end
