import React from 'react';
import * as R from 'ramda';
import clsx from 'clsx';
import { useDispatch, useSelector} from 'react-redux';
import { Redirect } from 'react-router-dom';

import {
  genHandleAuthSuccess,
  genHandleAuthFail,
} from '../../actions/authAction';

import {
  reduxSelect,
  actionReducer,
} from '../../common/functional';

import {
  login
} from '../../common/api';

const propsPath = [
  ['auth', 'error'],
  ['auth', 'isAuthenticated'],
];

const initialState = {
  form: {
    username: '',
    password: '',
  },
  loading: false,
};

const loadingLens = R.lensProp('loading');
const usernameLens = R.lensPath(['form','username']);
const passwordLens = R.lensPath(['form','password']);
const username = R.view(usernameLens);
const password = R.view(passwordLens);
const loading = R.view(loadingLens);

const genStartLoading = dispatch => () => dispatch(R.set(loadingLens, true));
const genStopLoading = dispatch => () => dispatch(R.set(loadingLens, false));
const genHandleField = R.curry((dispatch,field,data) => dispatch(
  R.set(R.lensPath(['form',field]), data)
));

function Login(props) {
  const { from } = props.location.state || { from: { pathname: "/admin/index" } };
  const [
    error,
    isAuthenticated,
  ] = reduxSelect(useSelector,propsPath);
  const globalDispatch = useDispatch();
  const [state, localDispatch] = React.useReducer(actionReducer,initialState);
  const startLoading = genStartLoading(localDispatch);
  const stopLoading = genStopLoading(localDispatch);
  const handleField = genHandleField(localDispatch);
  const handleAuthSuccess = genHandleAuthSuccess(globalDispatch);
  const handleAuthFail = genHandleAuthFail(globalDispatch);

  const handleCommit = () => {
    if(username(state) === '' || password(state) === ''){
      handleAuthFail();
    }
    startLoading();
    login(state.form).subscribe(
      (res) => {
        sessionStorage.setItem('token',res.token);
        stopLoading();
        handleAuthSuccess();
      },
      (err) => {
        stopLoading();
        handleAuthFail();
      }
    );
  };

  if (isAuthenticated) return <Redirect to={from} />;
  return (
    <div className="section">
      <div className="columns is-centered">
        <div className="column is-half">
          <div className="field">
            <label className="label">用户名</label>
            <div className="control has-icons-left has-icons-right">
              <input
                value={username(state)}
                onChange={e => handleField('username',e.target.value)}
                className={clsx('input',{'is-danger': error} )}
                type="text"
                placeholder="用户名"
              />
              <span className="icon is-small is-left">
                <i className="fas fa-user"></i>
              </span>
            </div>
          </div>
          <div className="field">
            <label className="label">密码</label>
            <div className="control has-icons-left has-icons-right">
              <input
                value={password(state)}
                onChange={e => handleField('password',e.target.value)}
                className={clsx('input',{'is-danger': error} )}
                type="password" placeholder="密码"
              />
              <span className="icon is-small is-left">
                <i className="fas fa-key"></i>
              </span>
            </div>
          </div>
          <div className="field">
            <p className="control">
              <button
                onClick={handleCommit}
                className="button is-success"
                disabled={loading(state)}
              >
                登陆
              </button>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Login;
