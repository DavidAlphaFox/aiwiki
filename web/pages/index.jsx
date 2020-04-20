import Layout from '../components/Layout';
import Topic from '../components/Topic';
import PageIndex from '../components/PageIndex';
import {
  fetchIndexPage,
} from '../api/server';
function Index(props){
  const {
    index,
    size,
    total,
    pages,
    topics,
  } = props;
  
  return (
    <Layout>
      <div className="md:flex md:pt-4 md:justify-center">
        <div className="pt-4 px-8 w-full h-full md:max-w-xl2">
          <PageIndex pages={pages} />
        </div>
        <aside className="pt-4 w-full md:mx-8 md:max-w-xs">
          <Topic topics={topics} />
        </aside>
      </div>
    </Layout>
  );
}

export async function getServerSideProps(context) {
  const result = await fetchIndexPage(context.query);
  return { props: result };
}

export default Index;
