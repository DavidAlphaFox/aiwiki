import fetch from 'node-fetch';
import * as R from 'ramda';
import Layout from '../components/Layout';
function Index(props){
  const {
    index,
    size,
    total,
    data,
  } = props;
  const renderPage = R.map((p) => {
    return (
      <li className="mt-6" key={p.id}>
        <div className="text-left">
          <a href={`/pages/${p.id}`} target="_blank">
            <h2 className="mb-4 text-lg font-bold"> {p.title }</h2>
          </a>
          <div className="text-gray-600">
            { p.intro }
            <a className="text-teal-500" href={`/pages/${p.id}`} target="_blank">阅读更多...</a>
          </div>
        </div>
      </li>
    );
  });
  
  return (
    <Layout>
      <div className="md:flex md:pt-4 md:justify-center">
        <div className="pt-4 px-8 w-full h-full md:max-w-xl2">
          <ul className="pb-4 md:mx-4">
            {renderPage(data)}
          </ul>
        </div>
      </div>
    </Layout>
  );
}

export async function getServerSideProps(context) {
  const url = new URL('http://localhost:5000/api/pages');
  R.mapObjIndexed((v,k,o) => url.searchParams.append(k,v),context.query);
  const remoteRes = await fetch(url);
  if(remoteRes.status === 200){
    const data = await remoteRes.json();
    return { props: data };
  }
  return { props: {} };
}

export default Index;
