import React from 'react';
import * as R from 'ramda';
import renderHTML from 'react-render-html';
import App from 'next/app';
import '../css/tailwind.css';
import {
  fetchSite,
} from '../api/server';

const brand = R.pipe(
  R.prop('brand'),
  R.ifElse(
    R.equals(undefined),
    R.always('AiWiki'),
    R.identity,
  ));

const footer = R.pipe(
  R.prop('footer'),
  R.ifElse(
    R.equals(undefined),
    R.always(null),
    renderHTML
  ));

class AiwikiApp extends App {

  static async getInitialProps(ctx) {
    const appProps = await App.getInitialProps(ctx)
    const res = await fetchSite();
    if (res === null){
      return appProps;
    }
    return {
      ...appProps,
      ...res,
    };
  }
  
  render() {
    const { Component, pageProps } = this.props;
    return (
      <React.Fragment>
        <header className="border-b border-teal-200 flex justify-between">
          <div className="text-left py-1 px-2">
            <a href="/">
              <span className="text-teal-500 text-xl">{brand(this.props)}</span>
            </a>
          </div>
          <div className="text-left py-1 px-2">
            <a href="/rss.xml">
              <span className="text-teal-500 text-xl">RSS</span>
            </a>
          </div>
        </header>
        <Component {...pageProps} />
        {footer(this.props)}
      </React.Fragment>
    );
  }
}

export default AiwikiApp;
