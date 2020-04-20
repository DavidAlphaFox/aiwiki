import Document, { Html, Head, Main, NextScript } from 'next/document';
import renderHTML from 'react-render-html';

import {
  fetchHeader,
} from '../api/server';

class AiwikiDocument extends Document {
  static async getInitialProps(ctx) {
    const appProps = await Document.getInitialProps(ctx);
    const res = await fetchHeader();
    if (res === null){
      return appProps;
    }
    return {
      ...appProps,
      ...res,
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
  renderHeader() {
    if(this.props.header === undefined) return null;
    return renderHTML(this.props.header);
  }
  render() {
    return (
      <Html>
        <Head>
          <meta charSet="utf-8" />
          <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
          <meta name="HandheldFriendly" content="True" />
          <meta name="MobileOptimized" content="320" />
          <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0" />
          {this.renderKeywords()}
          {this.renderIntro()}
          {this.renderHeader()}
        </Head>
        <body className="bg-white antialiased h-screen">
          <Main />
          <NextScript />
        </body>
      </Html>
    );
  }
}

export default AiwikiDocument
