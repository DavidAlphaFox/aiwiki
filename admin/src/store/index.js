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
const initialState = {
  pages: pagesInitialState,
  auth: authInitialState,
};

export default createStore(
  rootReducer,
  initialState,
  composeWithDevTools(applyMiddleware(...middleware)),
);
