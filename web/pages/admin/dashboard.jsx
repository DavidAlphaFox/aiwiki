import React from 'react';
import privateRoute from '../../components/PrivateRoute';

function Dashboard(){
  return(<div>dashboard </div>)
}

export default privateRoute(Dashboard);
