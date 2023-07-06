import { Modal } from "antd";

const SlotBookedSuccessModal = ({
  openSuccessModal,
  setSuccessModalOpen,
  successModalText,
}) => (
  <Modal
    open={openSuccessModal}
    onOk={() => setSuccessModalOpen(false)}
    onCancel={() => setSuccessModalOpen(false)}
    title="Slot booked"
  >
    <p>{successModalText}</p>
  </Modal>
);

export default SlotBookedSuccessModal;
