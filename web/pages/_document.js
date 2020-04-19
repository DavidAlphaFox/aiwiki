import Document, { Html, Head, Main, NextScript } from 'next/document'

class AiwikiDocument extends Document {

  render() {
    return (
      <Html>
        <Head />
        <body className="bg-white antialiased h-screen">
          <Main />
          <NextScript />
        </body>
      </Html>
    )
  }
}

export default AiwikiDocument
