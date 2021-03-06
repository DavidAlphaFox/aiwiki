import Document, { Html, Head, Main, NextScript } from 'next/document';
import parse from 'html-react-parser';
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
  renderHeader() {
    if(this.props.header === undefined) return null;
    return parse(this.props.header);
  }
  render() {
    return (
      <Html>
        <Head />
        <head>{this.renderHeader()}</head>
        <body className="bg-white antialiased h-screen">
          <Main />
          <NextScript />
        </body>
      </Html>
    );
  }
}

export default AiwikiDocument
