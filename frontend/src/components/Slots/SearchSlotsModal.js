import { Modal } from "antd";

const SearchSlotsModal = ({
  openModal,
  setModalOpen,
  modalText,
  createSlot,
}) => {
  return (
    <Modal
      open={openModal}
      onOk={() => createSlot()}
      onCancel={() => setModalOpen(false)}
      title="Create A Slot"
    >
      <p>{modalText}</p>
    </Modal>
  );
};

export default SearchSlotsModal;
