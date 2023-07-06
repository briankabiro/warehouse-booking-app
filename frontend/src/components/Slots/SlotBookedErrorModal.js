import { Modal } from "antd";

const SlotBookedErrorModal = ({
  errorModalOpen,
  errorModalText,
  setErrorModalOpen,
}) => (
  <Modal
    open={errorModalOpen}
    onOk={() => setErrorModalOpen(false)}
    onCancel={() => setErrorModalOpen(false)}
    title="Error when booking slot"
  >
    <p>{errorModalText}</p>
  </Modal>
);

export default SlotBookedErrorModal;
