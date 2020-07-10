import Head from 'next/head';
import Layout from '../components/Layout';
import Topic from '../components/Topic';
import PageIndex from '../components/PageIndex';
import Pager from '../components/Pager';
import {
  fetchIndexPage,
  fetchSite,
} from '../api';
function Index(props){
  const {
    index,
    size,
    total,
    pages,
    topics,
    brand = 'AiWiki',
  } = props;
  return (
    <Layout>
      <Head>
        <title>{brand}</title>
      </Head>
      <div className="md:flex md:pt-4 md:justify-center">
        <div className="pt-4 px-8 w-full h-full md:max-w-xl2">
          <PageIndex pages={pages} />
          <div className="mt-4 md:mx-4 flex justify-center">
            <Pager
              index={index}
              size={size}
              total={total}
              url="/"
            />
          </div>
        </div>
        <aside className="pt-4 w-full md:mx-8 md:max-w-xs">
          <Topic topics={topics} />
        </aside>
      </div>
    </Layout>
  );
}

export async function getServerSideProps(context) {
  const page = await fetchIndexPage(context.query);
  const site = await fetchSite();
  return { props:{
    ...page,
    ...site
  }};
}

export default Index;
