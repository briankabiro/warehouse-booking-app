import FullCalendar from "@fullcalendar/react"; // must go before plugins
import { useState, useEffect } from "react";
import timeGridPlugin from "@fullcalendar/timegrid";
import axios from "axios";
import dayjs from "dayjs";
const BOOKED_SLOTS_URL = `${process.env.REACT_APP_API_SLOTS_URL}/booked_slots`

const SlotsCalendar = () => {
  const [bookings, setBookings] = useState([]);

  const formatBookings = (bookings) => {
    return bookings.map(({ start_time, end_time }) => ({
      start: start_time,
      end: end_time,
    }));
  };

  const startOfWeek = () => {
    return dayjs().startOf("week").format();
  };

  const endOfWeek = () => {
    return dayjs().endOf("week").format();
  };

  useEffect(() => {
    axios
      .post(BOOKED_SLOTS_URL, {
        start_time: startOfWeek(),
        end_time: endOfWeek(),
      })
      .then((response) => {
        setBookings(formatBookings(response.data));
      })
      .catch((error) => {
        console.log("Error encountered", error);
      });
  }, []);

  const renderEventContent = (eventInfo) => (
    <>
      <b>{eventInfo.timeText}</b>
    </>
  );

  return (
    <>
      <h3>All bookings</h3>

      <FullCalendar
        plugins={[timeGridPlugin]}
        initialView=""
        events={bookings}
        eventContent={renderEventContent}
      />
    </>
  );
};

export default SlotsCalendar;
