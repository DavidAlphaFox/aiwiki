import React from 'react';
import ServerCookie from 'next-cookies';
import Router from 'next/router';
import {
  COOKIE_NAME,
  AuthToken,
} from '../services/authService';

function privateRoute(WrappedComponent) {
  return class extends React.Component {
    static async getInitialProps(ctx) {
      const token = ServerCookie(ctx)[COOKIE_NAME];
      const auth = new AuthToken(token);
      const initialProps = {auth};
      if(auth.isExpired()){
        ctx.res.writeHead(302,{
           Location: `/admin/login?redirect=${encodeURIComponent(ctx.req.url)}`,
        });
        ctx.res.end();
        return initialProps;
      }
      if (WrappedComponent.getInitialProps) return WrappedComponent.getInitialProps(initialProps);
      return initialProps;
    }
    auth(){
      return new AuthToken(this.props.auth.token);
    }
    render() {
      return <WrappedComponent auth={this.auth} {...this.props} />;
    }
  };
}


export default privateRoute;
