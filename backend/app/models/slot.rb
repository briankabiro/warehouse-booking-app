class Slot < ApplicationRecord
  DEFAULT_MAX_DURATION = 10.hours
  DEFAULT_MIN_DURATION = 10.minutes
  DEFAULT_START_MULTIPLE = 15
  DEFAULT_END_MULTIPLE = 5

  before_create :assign_uuid

  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :valid_start_time?
  validate :valid_end_time?
  validate :valid_duration?
  validate :valid_slot_times?
  validate :other_slot_overlap?

  private

  def assign_uuid
    self.id = SecureRandom.uuid
  end

  def valid_start_time?
    return unless start_time? && !multiple_of_start(start_time)

    errors.add(:start_time, 'should be a multiple of 15 minutes')
  end

  def valid_end_time?
    return unless end_time? && !multiple_of_end(end_time)

    errors.add(:end_time, 'should be a multiple of 5 minutes')
  end

  def valid_slot_times?
    return unless start_time? && end_time?

    if !end_time.after?(start_time)
      errors.add(:end_time, 'must be after start')
    end
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

  # TODO: move this code somewhere?
  def multiple_of_start(time)
    (minutes(time) % DEFAULT_START_MULTIPLE).zero? 
  end

  def multiple_of_end(time)
    (minutes(time) % DEFAULT_END_MULTIPLE).zero? 
  end
  
  def minutes(time)
    time.strftime('%M').to_i
  end
end
