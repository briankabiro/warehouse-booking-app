require 'rails_helper'

RSpec.describe 'Slots', type: :request do
  describe 'POST /slots' do
    let(:valid_date) { Date.current }
    let(:valid_duration) { '30m' }

    context 'valid times' do
      it 'should create a slot' do
        post '/api/v1/slots', params: {
          start_time: valid_date,
          end_time: valid_date + 20.minutes
        }
        slot = Slot.first

        expect(response).to have_http_status :ok
        json = JSON.parse(response.body)
        expect(json['id']).to eq slot.id
      end
    end

    context 'booked slots' do
      let(:valid_start) { 1.week.before }
      let(:valid_end) { 1.day.from_now }

      it 'returns the booked slots between a particular time' do
        start_time = Date.current.beginning_of_day
        end_time = start_time + 30.minutes

        Slot.create(
          start_time:,
          end_time:
        )

        post '/api/v1/slots/booked_slots', params: {
          start_time: valid_start,
          end_time: valid_end
        }

        expect(response).to have_http_status :ok
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
      end

      it 'returns a bad request if params are invalid' do
        post '/api/v1/slots/booked_slots', params: {
          start_time: nil,
          end_time: nil
        }

        expect(response).to have_http_status :bad_request
      end
    end

    context 'invalid times' do
      it 'should not create a slot when times are not valid' do
        post '/api/v1/slots', params: {
          start_time: nil,
          end_time: nil
        }

        expect(response).to have_http_status :bad_request
        json = JSON.parse(response.body)
        expect(json).to have_key('errors')
        expect(json['errors']).to eq('Invalid start or end time')
      end
    end
  end

  describe 'POST /search' do
    let(:valid_date) { Date.current }
    let(:valid_duration) { '30m' }

    context 'valid params' do
      it 'returns a 200 response' do
        post '/api/v1/slots/search', params: { duration: valid_duration, date: valid_date, timezone: 'Africa/Nairobi' }

        expect(response).to have_http_status :ok
      end

      it 'returns available slots' do
        post '/api/v1/slots/search', params: { duration: valid_duration, date: valid_date, timezone: 'Africa/Nairobi' }

        json = JSON.parse(response.body)
        expect(json).not_to be_empty
      end

      it 'does not return booked slots' do
        start_time = 1.day.from_now.beginning_of_day
        end_time = start_time + 30.minutes

        Slot.create(
          start_time:,
          end_time:
        )

        post '/api/v1/slots/search', params: { duration: valid_duration, date: valid_date, timezone: 'Africa/Nairobi' }
      end
    end

    context 'invalid params' do
      it 'returns an error when duration is invalid' do
        post '/api/v1/slots/search', params: { duration: 'x', date: valid_date }

        expect(response).to have_http_status :bad_request
      end

      it 'returns an error when date is invalid' do
        post '/api/v1/slots/search', params: { duration: '30m', date: 'x' }

        expect(response).to have_http_status :bad_request
      end

      it 'returns an error when timezone is invalid' do
        post '/api/v1/slots/search', params: { duration: '30m', date: valid_date, timezone: 'x' }

        expect(response).to have_http_status :bad_request
      end
    end
  end
end
