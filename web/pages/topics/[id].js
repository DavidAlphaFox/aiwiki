import * as R from 'ramda';
import Layout from '../../components/Layout';
import Topic from '../../components/Topic';
import PageIndex from '../../components/PageIndex';
import {
  fetchIndexPage,
} from '../../api/server';

function TopicIndex(props){
  const {
    index,
    size,
    total,
    pages,
    topics,
    topic,
  } = props;

  const topicItem = React.useMemo(
    () => R.find(i => (i.id === topic),topics),
    [topic,topics]);
  const renderTopic = () => {
    if(topicItem === undefined) return null;
    return (
      <div className="pb-4 md:mx-4">
        <div>
          <h1 className="font-bold text-lg">{ topicItem.title }</h1>
        </div>
        <div>
          <span>{topicItem.intro}</span>
        </div>
      </div>
    );
  };
  return (
    <Layout>
      <div className="md:flex md:pt-4 md:justify-center">
        <div className="pt-4 px-8 w-full h-full md:max-w-xl2">
          {renderTopic()}
          <PageIndex pages={pages} />
        </div>
        <aside className="pt-4 w-full md:mx-8 md:max-w-xs">
          <Topic topics={topics} selected={topic} />
        </aside>
      </div>
    </Layout>
  );
}

export async function getServerSideProps(context) {
  const {
    query,
    params,
  } = context;
  const apiQuery = {
    ...query,
    topic: params.id,
  };
  const result = await fetchIndexPage(apiQuery);
  return { props: {
    ...result,
    topic: params.id,
  }};
}

export default TopicIndex;
