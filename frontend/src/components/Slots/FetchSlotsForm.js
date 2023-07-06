import { Button, DatePicker, TimePicker, Space } from "antd";
import dayjs from "dayjs";
var localizedFormat = require("dayjs/plugin/localizedFormat");
dayjs.extend(localizedFormat);

const FetchSlotsForm = ({ handleDuration, setDate, fetchSlots }) => {
  const disabledSlotDate = (date) => {
    if (!date) {
      return false;
    }

    let yesterday = dayjs().add(-1, "day");
    return date.valueOf() < yesterday;
  };

  return (
    <form id="fetch-slots-form">
      <Space>
        <TimePicker
          onChange={(time, timeString) => handleDuration(timeString)}
          minuteStep="5"
          format="H:mm"
          defaultValue={dayjs("00:15", "H:mm")}
        />

        <DatePicker
          disabledDate={disabledSlotDate}
          onChange={(date, dateString) => setDate(dateString)}
          picker="date"
          size="middle"
          defaultValue={dayjs()}
          format="ll"
        />
        <Button
          style={{ background: "#00b96b" }}
          onClick={fetchSlots}
          type="primary"
        >
          Get Slots
        </Button>
      </Space>
    </form>
  );
};

export default FetchSlotsForm;
