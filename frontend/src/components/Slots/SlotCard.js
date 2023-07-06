import { formatTimetoHHMM } from "../../utils/utils";
import { Card } from "antd";

const SlotCard = ({ slot, index, handleCardClick }) => {
  return (
    <div className="slot" key={index}>
      <Card type="primary" onClick={() => handleCardClick(slot)} hoverable>
        {formatTimetoHHMM(slot.start_time)} - {formatTimetoHHMM(slot.end_time)}
      </Card>
    </div>
  );
};

export default SlotCard;
