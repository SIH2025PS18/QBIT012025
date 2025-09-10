import React from 'react';
import { useParams } from 'react-router-dom';

const MedicineDetails = () => {
  const { id } = useParams();

  return (
    <div className="flex justify-center items-center h-screen">
      <h1 className="text-3xl font-bold">Medicine Details for ID: {id}</h1>
    </div>
  );
};

export default MedicineDetails;
