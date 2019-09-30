import { createStore, applyMiddleware } from 'redux';
import { composeWithDevTools } from 'redux-devtools-extension';
import thunk from 'redux-thunk';
import {
  pagesInitialState,
} from '../actions/pagesAction';

import {
  authInitialState,
} from '../actions/authAction';

import rootReducer from '../reducers';
const middleware = [ thunk ];
const createState = () => {
  const token = sessionStorage.getItem('token');
  if (token === undefined){
    return {
      pages: pagesInitialState,
      auth: authInitialState,
    };
  }
  return {
    pages: pagesInitialState,
    auth: {
      ...authInitialState,
      isAuthenticated: true,
    },
  };
};



export default createStore(
  rootReducer,
  createState(),
  composeWithDevTools(applyMiddleware(...middleware)),
);
