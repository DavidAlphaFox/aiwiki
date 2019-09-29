import React from 'react';
import clsx from 'clsx';
import { useSelector} from 'react-redux';
import { Redirect } from 'react-router-dom';

import {
  reduxSelect
} from '../../common/functional';

const propsPath = [
  ['auth', 'error'],
  ['auth', 'isAuthenticated'],
];

function Login(props) {
  const { from } = props.location.state || { from: { pathname: "/admin/index" } };
  const [
    error,
    isAuthenticated,
  ] = reduxSelect(useSelector,propsPath);

  if (isAuthenticated) return <Redirect to={from} />;
  return (
    <div className="section">
      <div className="columns is-centered">
        <div className="column is-half">
          <div className="field">
            <label className="label">用户名</label>
            <div className="control has-icons-left has-icons-right">
              <input className={clsx('input',{'is-danger': error} )} type="text" placeholder="用户名" />
              <span className="icon is-small is-left">
                <i className="fas fa-user"></i>
              </span>
            </div>
          </div>
          <div className="field">
            <label className="label">密码</label>
            <div className="control has-icons-left has-icons-right">
              <input className={clsx('input',{'is-danger': error} )} type="password" placeholder="密码" />
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
