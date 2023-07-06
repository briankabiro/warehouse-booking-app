import axios from "axios";
import { useState } from "react";
import dayjs from "dayjs";
import {
  convertTimeFormat,
  formatTimetoHHMM,
  formatTimeToDay,
} from "../utils/utils";
import { Space } from "antd";
import SlotCard from "./Slots/SlotCard";
import FetchSlotsForm from "./Slots/FetchSlotsForm";
import SearchSlotsModal from "./Slots/SearchSlotsModal";
import SlotBookedSuccessModal from "./Slots/SlotBookedSuccessModal";
import SlotBookedErrorModal from "./Slots/SlotBookedErrorModal";
var localizedFormat = require("dayjs/plugin/localizedFormat");
dayjs.extend(localizedFormat);
const API_SLOTS_URL = `${process.env.REACT_APP_API_SLOTS_URL}`
const SEARCH_SLOTS_URL = `${API_SLOTS_URL}/search`

export default function SlotsComponent() {
  const [date, setDate] = useState(dayjs());
  const [duration, setDuration] = useState("00:15");
  const [availableSlots, setAvailableSlots] = useState([]);
  const [openModal, setModalOpen] = useState(false);
  const [modalText, setModalText] = useState("");
  const [currentSlot, setCurrentSlot] = useState({});
  const [openSuccessModal, setSuccessModalOpen] = useState(false);
  const [successModalText, setSuccessModalText] = useState("");
  const [errorModalOpen, setErrorModalOpen] = useState(false);
  const [errorModalText, setErrorModalText] = useState("");
  const [noSlotsText, setNoSlotsText] = useState("");

  const fetchSlots = (e) => {
    e.preventDefault();
  
    if (!date || !duration) {
      return;
    }
  
    let { timeZone } = Intl.DateTimeFormat().resolvedOptions();
  
    axios
      .post(SEARCH_SLOTS_URL, {
        date: date,
        duration: convertTimeFormat(duration),
        timezone: timeZone,
      })
      .then((response) => {
        setAvailableSlots(response.data);
        setNoSlotsText(`No slots available for ${formatTimeToDay(date)}. Please choose another date.`);
      })
      .catch((error) => {
        setNoSlotsText(`Error fetching slots for ${formatTimeToDay(date)}. Please try again later.`);
      });
  };

  const handleSuccessfulSlotBooking = (response) => {
    let start_time = formatTimetoHHMM(response.data.start_time);
    let end_time = formatTimetoHHMM(response.data.end_time);
    let successModalText = `Slot booked successfully from ${start_time} to ${end_time} on ${formatTimeToDay(date)}`;
  
    setSuccessModalText(successModalText);
    setSuccessModalOpen(true);
    removeCurrentSlot();
  };
  
  const createSlot = () => {
    axios
      .post(API_SLOTS_URL, {
        start_time: currentSlot.start_time,
        end_time: currentSlot.end_time,
      })
      .then((response) => {
        handleSuccessfulSlotBooking(response);
      })
      .catch((error) => {
        setErrorModalOpen(true);
        setErrorModalText("Slot not created. Kindly book a slot at another time");
      });
  
    setModalOpen(false);
  };

  const removeCurrentSlot = () => {
    setAvailableSlots((prevList) =>
      prevList.filter((obj) => obj.start_time !== currentSlot.start_time),
    );
  };

  const handleDuration = (timeString) => {
    setDuration(timeString);
  };

  const generateModalText = (slot) => {
    let start_time = formatTimetoHHMM(slot.start_time);
    let end_time = formatTimetoHHMM(slot.end_time);
    return `Book a slot from ${start_time} to ${end_time} on ${formatTimeToDay(date)}`;
  };
  
  const handleCardClick = (slot) => {
    setCurrentSlot(slot);
    setModalOpen(true);
    setModalText(generateModalText(slot));
  };

  return (
    <>
      <Space direction="vertical" size="middle">
        <FetchSlotsForm
          setDate={setDate}
          fetchSlots={fetchSlots}
          handleDuration={handleDuration}
        />

        <SearchSlotsModal
          openModal={openModal}
          createSlot={createSlot}
          setModalOpen={setModalOpen}
          modalText={modalText}
        />

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

        <Space direction="vertical">
          {availableSlots.length === 0 ? (
            <p>{noSlotsText}</p>
          ) : (
            availableSlots.map((slot, index) => (
              <SlotCard
                handleCardClick={handleCardClick}
                index={index}
                slot={slot}
              />
            ))
          )}
        </Space>
      </Space>
    </>
  );
}
