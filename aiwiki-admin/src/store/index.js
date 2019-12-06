import { createStore, applyMiddleware } from 'redux';
import { composeWithDevTools } from 'redux-devtools-extension';
import thunk from 'redux-thunk';

import rootReducer from '../reducers';
const middleware = [ thunk ];
const createState = () => {
  return {
    auth: {
      isAuthenticated: true,
    },
  };
};

const createReduxStore = () => {
  const initState = createState();
  return createStore(
    rootReducer,
    initState,
    composeWithDevTools(applyMiddleware(...middleware)),
  );
};

export {
  createReduxStore,
  createState,
};
