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
const createState = (token) => {
  sessionStorage.setItem('token',token);
  if (token === undefined || token === null){
    sessionStorage.removeItem('token');
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

const createReduxStore = (initState) => createStore(
  rootReducer,
  initState,
  composeWithDevTools(applyMiddleware(...middleware)),
);

export {
  createReduxStore,
  createState,
};
