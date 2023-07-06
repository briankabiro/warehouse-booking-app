class SlotParamsValidator
  include ActiveModel::Validations
  attr_reader :data

  validates :timezone, inclusion: { in: TZInfo::Timezone.all_identifiers }
  validates :date, presence: true
  validates :duration, presence: true
  validate :valid_date?
  validate :valid_duration?

  def initialize(data)
    @data = data
  end

  def read_attribute_for_validation(key)
    data[key]
  end

  def valid_date?
    Date.parse(data[:date])
  rescue Date::Error
    false
  end

  def valid_duration?
    # debugger
    duration = ChronicDuration.parse(data[:duration])
  
    return false if !duration || duration > 10.hours || duration < 10.minutes
  rescue ChronicDuration::DurationParseError
    false
  end
end