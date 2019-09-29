import React from 'react';
import * as R from 'ramda';
import clsx from 'clsx';
import { useDispatch, useSelector} from 'react-redux';
import { Redirect } from 'react-router-dom';

import {
  reduxSelect,
  actionReducer,
} from '../../common/functional';

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


function Login(props) {
  const { from } = props.location.state || { from: { pathname: "/admin/index" } };
  const [
    error,
    isAuthenticated,
  ] = reduxSelect(useSelector,propsPath);
  const globalDispatcher = useDispatch();
  const [state, localDispatcher] = React.useReducer(actionReducer,initialState);
  
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
              <button className="button is-success"> 登陆 </button>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Login;
