import * as R from 'ramda';

import notExsist from './notExsist';

const doIt = state => R.ifElse(
  notExsist,
  R.always(state),
  R.applyTo(state),
);

const actionReducer = (state, action) => doIt(state)(action);

export default actionReducer;
