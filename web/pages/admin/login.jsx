import React from 'react';
import Router from "next/router";
import Cookie from "js-cookie";
import {
  actionReducer,
  lensValueTo,
  notExist,
} from '../../functional';
import {
  auth,
} from '../../api';

function Login() {
  
  const emailRef = React.useRef();
  const passwordRef = React.useRef();
  const handleAuth = React.useCallback((e) => {
    e.preventDefault();
    auth().subscribe(
      (data) => {
        Cookie.set('aiwiki.authToken', data.token);
        Router.push("/admin/dashboard");
      },
      (err) => { console.log(err) })
  },[]);
  return (
    <div className="pt-20 flex justify-center h-full">
      <div className="w-full max-w-sm">
        <form className="border border-gray-200 bg-white shadow-md pt-6" onSubmit={handleAuth}>
          <div className="mb-4 px-8 text-center">
            <span className="text-xl">登录</span>
          </div>
          <div className="mb-4 px-8">
            <label className="block label-color text-sm font-bold mb-2">
              邮箱
            </label>
            <input
              className="border rounded shadow w-full py-2 px-3 label-color focus:shadow-outline"
              name="email"
              type="text"
              placeholder="邮箱"
              ref={emailRef}
            />
          </div>
          <div className="mb-4 px-8">
            <label className="block label-color text-sm font-bold mb-2" >
              密码
            </label>
            <input
              className="border shadow rounded w-full py-2 px-3 label-color mb-3 focus:shadow-outline"
              name="password"
              type="password"
              placeholder="******************"
              ref={passwordRef}
            />
          </div>

          <div>
            <button
              className="primary-bg-color hover:primary-bg-color w-full text-white font-bold py-2"
            >
              登录
            </button>
          </div>
        </form>
      </div>
    </div>
  );

};

export default Login;
