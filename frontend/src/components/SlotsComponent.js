import axios from 'axios';
import { useState } from 'react';
import dayjs from 'dayjs';
import { convertTimeFormat, formatTimetoHHMM, formatTimeToDay } from '../utils/utils';
import SlotCard from './Slots/SlotCard';
import FetchSlotsForm from './Slots/FetchSlotsForm';
import SearchSlotsModal from './Slots/SearchSlotsModal';
import SlotBookedSuccessModal from './Slots/SlotBookedSuccessModal';
import SlotBookedErrorModal from './Slots/SlotBookedErrorModal';
var localizedFormat = require('dayjs/plugin/localizedFormat')
dayjs.extend(localizedFormat);

export default function SlotsComponent () {
  const [date, setDate] = useState(dayjs());
  const [duration, setDuration] = useState('00:15');
  const [availableSlots, setAvailableSlots] = useState([]);
  const [openModal, setModalOpen] = useState(false);
  const [modalText, setModalText] = useState('');
  const [currentSlot, setCurrentSlot] = useState({});
  const [openSuccessModal, setSuccessModalOpen] = useState(false);
  const [successModalText, setSuccessModalText] = useState('');
  const [errorModalOpen, setErrorModalOpen] = useState(false);
  const [errorModalText, setErrorModalText] = useState('');
  const [noSlotsText, setNoSlotsText] = useState('');

  const fetchSlots = (e) => {
    e.preventDefault();

    if (!date || !duration) {
      return;
    }

    let { timeZone } = Intl.DateTimeFormat().resolvedOptions(); 

    axios.post('http://localhost:3000/api/v1/slots/search', {
      date: date,
      duration: convertTimeFormat(duration),
      timezone: timeZone
    }).then((response) => {
      setAvailableSlots(response.data);
      setNoSlotsText(`No slots to show for ${formatTimeToDay(date)}. Kindly choose another date`);
    }).catch((error) => {
      setNoSlotsText(`Error when fetching slots for ${formatTimeToDay(date)}. Kindly choose another date`);
    })
  }

  const createSlot = () => {
    axios.post('http://localhost:3000/api/v1/slots', {
      start_time: currentSlot.start_time,
      end_time: currentSlot.end_time 
    }).then((response) => {      
      // TODO: move this logic to a function instead of writing all logic here
      let start_time = formatTimetoHHMM(response.data.start_time);
      let end_time = formatTimetoHHMM(response.data.end_time);
      let successModalText = `Slot booked successfully from ${start_time} to ${end_time} on ${formatTimeToDay(date)}`;
      
      setSuccessModalText(successModalText);
      setSuccessModalOpen(true);
      removeCurrentSlot();
    }).catch((error) => {
      setErrorModalOpen(true);
      setErrorModalText("Slot not created. Kindly book a slot at another time");
    });

    setModalOpen(false);
  }

  const removeCurrentSlot = () => {
    setAvailableSlots(prevList => prevList.filter(obj => obj.start_time !== currentSlot.start_time))
  }

  const handleDuration = (timeString) => {
    setDuration(timeString);
  }

  const handleCardClick = (slot) => {
    setCurrentSlot(slot);
    setModalOpen(true);
    let start_time = formatTimetoHHMM(slot.start_time)
    let end_time = formatTimetoHHMM(slot.end_time)
    let modal_text = `Book a slot from ${start_time} to ${end_time} on ${formatTimeToDay(date)}`;
    setModalText(modal_text);
  }

  return (
    <>
      <FetchSlotsForm setDate={setDate} fetchSlots={fetchSlots} handleDuration={handleDuration} />

      <SearchSlotsModal openModal={openModal} createSlot={createSlot} setModalOpen={setModalOpen} modalText={modalText} />

      <SlotBookedSuccessModal
        openSuccessModal={openSuccessModal}
        setSuccessModalOpen={setSuccessModalOpen}
        successModalText={successModalText}
      />

      <SlotBookedErrorModal
        errorModalOpen={errorModalOpen}
        setErrorModalOpen={setErrorModalOpen}
        errorModalText={errorModalText}
      />

      {availableSlots.length === 0 ? (
        <p>{noSlotsText}</p>
      ) : (
        availableSlots.map((slot, index) => (
          <SlotCard handleCardClick={handleCardClick} index={index} slot={slot} />
        ))
      )}
      </>
  )
}