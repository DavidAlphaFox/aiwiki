import React from 'react';

import { Redirect, Route } from 'react-router-dom';
import { useSelector} from 'react-redux';

import {
  reduxSelect
} from '../../common/functional';

const propsPath = [
  ['auth', 'isAuthenticated'],
];

function PrivateRoute({component: C, ...rest}) {
  const [
    isAuthenticated,
  ] = reduxSelect(useSelector,propsPath);
  return (
    <Route
      {...rest}
      render={ (props) => {
        if(isAuthenticated){
          return <C {...props} />;
        }
        return <Redirect to={{
          pathname: '/admin/login',
          state: { from : props.location },
        }}/>
      }}
    />
  );
};

export default PrivateRoute;
