import fetch from 'node-fetch';
import renderHTML from 'react-render-html';
import { useRouter } from 'next/router';
import Link from 'next/link';
import Head from 'next/head';

import {
  fetchSite,
  fetchPage,
} from '../../api';

import Layout from '../../components/Layout';


function Page(props) {
  const {
    title = null,
    content = null,
    brand = 'AiWiki',
  } = props;
  if(content == null && title == null) return null;
  return (
    <Layout>
      <Head>
        <title>
          {`${title}-${brand}`}
        </title>
      </Head>
      <div className="pt-8">
        <h1 className="text-center font-bold text-2xl mx-2">{title}</h1>
        <div className="mt-4 mx-4 md:mx-64 content">
          {renderHTML(content)}
        </div>
      </div>
    </Layout>
  );
}
export async function getServerSideProps(context) {
  // Fetch data from external API
  const {
    res,
    params,
  } = context;
  const page = await fetchPage(params.id);
  if(page == null || page == undefined) {
    context.res.writeHead(404);
    context.res.end();
    return { props: {} };
  }
  const site = await fetchSite();
  return { props: {
    ...page,
    ...site
  }};
}

export default Page;
