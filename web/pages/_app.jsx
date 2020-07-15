import React from 'react';
import * as R from 'ramda';
import parse from 'html-react-parser';
import App from 'next/app';
import Head from 'next/head';

import '../css/tailwind.css';
import {
  fetchSite,
} from '../api';

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
    R.always(''),
    footer => parse(footer)
  ));

class AiwikiApp extends App {

  static async getInitialProps(ctx) {
    const appProps = await App.getInitialProps(ctx)
    const site = await fetchSite();
    return {
      ...appProps,
      ...site,
    };
  }

  renderKeywords() {
    if(this.props.keywords === undefined) return null;
    return (<meta name="keywords" content={this.props.keywords} />);
  }

  renderIntro() {
    if(this.props.intro === undefined) return null;
    return (<meta name="description" content={this.props.intro} />);
  }
  
  render() {
    const { Component, pageProps,router } = this.props;

    if(router.pathname.startsWith('/admin')) {
      return (
        <React.Fragment>
          <Component {...pageProps} />
        </React.Fragment>);
    }


    return (
      <React.Fragment>
        <Head>
          <meta charSet="utf-8" />
          <meta httpEquiv="X-UA-Compatible" content="IE=Edge" />
          <meta name="HandheldFriendly" content="True" />
          <meta name="MobileOptimized" content="320" />
          <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0" />
          {this.renderKeywords()}
          {this.renderIntro()}
        </Head>
        <header className="border-b border-indigo-200 flex justify-between">
          <div className="text-left py-1 px-2">
            <a href="/">
              <span className="text-indigo-500 text-xl">{brand(this.props)}</span>
            </a>
          </div>
          <div className="text-left py-1 px-2">
            <a href="/rss.xml">
              <span className="text-indigo-500 text-xl">RSS</span>
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
