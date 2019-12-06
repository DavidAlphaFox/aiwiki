import { combineReducers } from 'redux';
import {
  genActionTypeReducer,
  noopObjReducer,
} from '../common/functional';

export default combineReducers({
  auth: noopObjReducer,
});
