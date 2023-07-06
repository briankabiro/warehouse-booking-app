require 'rails_helper'

RSpec.describe Slot, type: :model do
  describe 'validations' do
    let(:start_time) { Date.current.beginning_of_day }

    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }

    context 'valid start_time and end_time' do
      it 'should save the slot' do
        slot = Slot.new(start_time:, end_time: start_time + 1.hour)

        expect(slot).to be_valid
      end
    end

    context 'invalid start_time and end_time' do
      it 'should not save when duration is less than MIN_DURATION' do
        slot = Slot.new(start_time:, end_time: start_time + 5.minutes)

        expect(slot).not_to be_valid
      end

      it 'should not save when duration is more than MAX_DURATION' do
        slot = Slot.new(start_time:, end_time: start_time + 12.hours)

        expect(slot).not_to be_valid
      end
    end

    context 'start_time should be less than end_time' do
      it 'should not save the slot' do
        slot = Slot.new(start_time:, end_time: 1.day.ago)

        expect(slot).not_to be_valid
      end
    end

    context 'start_time should be multiple of 15' do
      it 'should not save the slot' do
        slot = Slot.new(start_time: start_time + 2.minutes, end_time: start_time + 30.minutes)

        expect(slot).not_to be_valid
      end
    end

    context 'end_time' do
      it 'should save the slot if end time is a multiple of 5' do
        slot = Slot.new(start_time:, end_time: start_time + 10.minutes)

        expect(slot).to be_valid
      end

      it 'should not save the slot if end time is not a multiple of 5' do
        slot = Slot.new(start_time:, end_time: start_time + 7.minutes)

        expect(slot).not_to be_valid
      end
    end

    context 'overlapping slots' do
      let(:start_time) { Time.current }
      let(:end_time) { 1.hour.from_now }
      let!(:slot) { Slot.create(start_time:, end_time:) }

      it 'validates slots are unique' do
        duplicate_slot = Slot.new(start_time:, end_time: 5.minutes.from_now)

        expect(duplicate_slot).not_to be_valid
      end
    end
  end
end
