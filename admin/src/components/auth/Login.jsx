import React from 'react';

function Login(props) {
  return (
    <div className="section">
      <div className="field">
        <label className="label">用户名</label>
        <div className="control has-icons-left has-icons-right">
          <input className="input is-success" type="text" placeholder="用户名" />
          <span className="icon is-small is-left">
            <i className="fas fa-user"></i>
          </span>
        </div>
      </div>
      <div className="field">
        <label className="label">密码</label>
        <div className="control has-icons-left has-icons-right">
          <input className="input is-success" type="password" placeholder="密码" />
          <span className="icon is-small is-left">
            <i className="fas fa-key"></i>
          </span>
        </div>
      </div>
    </div>
  );
}

export default Login;
