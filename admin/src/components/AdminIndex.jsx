import React from 'react';
import {
  Navbar,
  AdminAction,
} from './nav';

function AdminIndex() {

  return (
    <div>
      <Navbar fixed={false}>
        <AdminAction />
      </Navbar>
    </div>
  );
}

export default AdminIndex;
