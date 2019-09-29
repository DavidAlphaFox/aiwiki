import { combineReducers } from 'redux';
import {
  genActionTypeReducer,
} from '../common/functional';

import {
  pagesActionType,
  pagesInitialState,
} from '../actions/pagesAction';

import {
  authActionType,
  authInitialState,
} from '../actions/authAction';

const pagesReducer = genActionTypeReducer(pagesActionType, pagesInitialState);
const authReducer = genActionTypeReducer(authActionType, authInitialState);
export default combineReducers({
  pages: pagesReducer,
  auth: authReducer,
});
