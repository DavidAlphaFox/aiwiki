import React from 'react';
import Router from "next/router";
import Cookie from "js-cookie";

import {
  auth,
} from '../../api';

function Login(){
  const handleAuth = React.useCallback(() => {
    auth().subscribe(
      (data)=> {
        Cookie.set('aiwiki.authToken',data.token);
        Router.push("/admin");
      },
      (err)=> { console.log(err)})
  });
  return (
    <div>
      <form>
        <button onClick={handleAuth}> 登陆 </button>
      </form>
    </div>
  );

};

export default Login;
