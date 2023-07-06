import SlotsComponent from './SlotsComponent';
import React, { useState } from 'react';
import SlotsCalendar from './Slots/SlotsCalendar';
import { PlusOutlined } from '@ant-design/icons';
import { Button, Modal } from 'antd';
import NavBar from './NavBar/NavBar';

const Home = () => {
  const [getSlotsModalOpen, setGetSlotsModalOpen] = useState(false);

  const showModal = () => {
    setGetSlotsModalOpen(true);
  };

  const handleOk = () => {
    setGetSlotsModalOpen(false);
  };

  const handleCancel = () => {
    setGetSlotsModalOpen(false);
  };

  return (
    <>
      <NavBar />
      
      <div id='new-booking-section'>
        <Button onClick={showModal} id='new-booking-button' size='large' type='primary' icon={<PlusOutlined />}>
          New Booking
        </Button>
      </div>
      
      <SlotsCalendar />

      <Modal title="Search Available Slots" open={getSlotsModalOpen} onOk={handleOk} onCancel={handleCancel}>
        <SlotsComponent />
      </Modal>
    </>
  )
}

export default Home;