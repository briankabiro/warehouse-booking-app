require 'rails_helper'

RSpec.describe "Slots", type: :request do
  describe 'POST /slots' do
    let(:valid_date) { Date.current }
    let(:valid_duration) { "30m" }

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

    context 'invalid times' do
      it 'should not create a slot when times are not valid' do
        post '/api/v1/slots', params: { 
          start_time: nil,
          end_time: nil
        }

        expect(response).to have_http_status :bad_request
        json = JSON.parse(response.body)
        expect(json["start_time"]).not_to be_empty
        expect(json["end_time"]).not_to be_empty
      end
    end
  end
  
  describe 'POST /search' do
    let(:valid_date) { Date.current }
    let(:valid_duration) { "30m" }

    context 'valid params' do
      it 'returns a 200 response' do
        post '/api/v1/slots/search', params: { duration: valid_duration, date: valid_date, timezone: "Africa/Nairobi" }

        expect(response).to have_http_status :ok
      end

      it 'returns available slots' do
        start_time = 1.day.from_now.beginning_of_day
        end_time = start_time + 30.minutes
  
        Slot.create(
          start_time: start_time,
          end_time: end_time
        )
  
        post '/api/v1/slots/search', params: { duration: valid_duration, date: valid_date, timezone: "Africa/Nairobi" }
  
        json = JSON.parse(response.body)
        expect(json.size).to eq(1)
      end
    end

    context 'invalid params' do
      it 'returns an error when duration is invalid' do
        post '/api/v1/slots/search', params: { duration: "x", date: valid_date }

        expect(response).to have_http_status :bad_request
      end

      it 'returns an error when date is invalid' do
        post '/api/v1/slots/search', params: { duration: "30m", date: "x" }
        
        expect(response).to have_http_status :bad_request
      end

      it 'returns an error when timezone is invalid' do
        post '/api/v1/slots/search', params: { duration: "30m", date: valid_date, timezone: "x" }
        
        expect(response).to have_http_status :bad_request
      end
    end 
  end
end