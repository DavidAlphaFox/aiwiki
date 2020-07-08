import fetch from 'node-fetch';
import renderHTML from 'react-render-html';
import { useRouter } from 'next/router';
import Link from 'next/link';
import Layout from '../../components/Layout';

function Page({data}) {
  if(data === undefined) return null;
  
  return (
    <Layout>
      <div className="pt-8">
        <h1 className="text-center font-bold text-2xl mx-2">{data.title}</h1>
        <div className="mt-4 mx-4 md:mx-64 content">
          {renderHTML(data.content)}
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
  const remoteRes = await fetch(`http://localhost:5000/api/pages/${params.id}`);
  if(remoteRes.status === 200){
    const data = await remoteRes.json();
    return { props: data };
  }
  context.res.writeHead(404);
  context.res.end();
  return { props: {} };
}


export default Page;
