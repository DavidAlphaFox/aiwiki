import * as R from 'ramda';

import notExsist from './notExsist';

const doIt = state => R.ifElse(
  notExsist,
  R.always(state),
  R.applyTo(state),
);

const actionReducer = (state, action) => doIt(state)(action);
const genActionTypeReducer = (types, initialState) => (state = initialState, action) => {
  if (R.includes(R.prop('type', action), types)) {
    return doIt(state)(R.prop('f', action));
  }
  return state;
};
const noopObjReducer = (state = {}, action) => state;
const noopArrayReducer = (state = [], action) => state;
export {
  actionReducer,
  genActionTypeReducer,
  noopObjReducer,
  noopArrayReducer,
};
