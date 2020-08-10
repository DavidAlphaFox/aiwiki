import fetch from 'node-fetch';
import parse from 'html-react-parser';
import * as R from 'ramda';
import { useRouter } from 'next/router';
import Link from 'next/link';
import Head from 'next/head';

import {
  fetchSite,
  fetchPage,
  fetchSidebar,
} from '../../api/server';

import Layout from '../../components/Layout';

function Page(props) {
  const {
    title = null,
    content = null,
    brand = 'AiWiki',
    sidebar = null
  } = props;
  if(content == null && title == null) return null;
  return (
    <Layout>
      <Head>
        <title>
          {`${title}-${brand}`}
        </title>
      </Head>
      <div className="pt-8 flex flex-wrap">
        <div className="w-full md:w-3/4 px-4">
          <h1 className="text-center font-bold text-2xl mx-2">{title}</h1>
          <div className="mt-4 content">
            {parse(content)}
          </div>
        </div>
        <div className="w-full md:w-1/4 px-4">
          <div>
            {R.ifElse(
              R.equals(null),
              R.always(''),
              payload => parse(payload),
            )(sidebar)}
          </div>
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
  const sidebar = await fetchSidebar();
  return { props: {
    ...page,
    ...site,
    ...sidebar
  }};
}

export default Page;
