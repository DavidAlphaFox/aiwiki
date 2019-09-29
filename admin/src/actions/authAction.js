import * as R from 'ramda';


const AUTH_SUCCESS = Symbol('AUTH_SUCCESS');
const AUTH_ERROR = Symbol('AUTH_ERROR');
const authActionType = [AUTH_SUCCESS, AUTH_ERROR];

const authInitialState = {
  isAuthenticated: false,
  error: false,
};

const genHandleAuthSuccess = (dispatch) => () => dispatch({
  type: AUTH_SUCCESS,
  f: R.pipe(
    R.set(R.lensProp('error'), false),
    R.set(R.lensProp('isAuthenicated'), true),
  ),
});

const genHandleAuthFail = (dispatch) => () => dispatch({
  type: AUTH_ERROR,
  f:R.pipe(
    R.set(R.lensProp('error'), true),
    R.set(R.lensProp('isAuthenicated'), false),
  ),
});


export {
  authActionType,
  authInitialState,
  genHandleAuthSuccess,
  genHandleAuthFail,
};
