import { combineReducers } from 'redux';
import {
  genActionTypeReducer
} from '../common/functional';

import {
  pagesActionType,
  pagesInitialState,
} from '../actions/pagesAction';

const pagesReducer = genActionTypeReducer(pagesActionType, pagesInitialState);
console.log(pagesReducer);
export default combineReducers({
  pages: pagesReducer,
});
