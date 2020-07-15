import React from 'react';
import { useRouter } from 'next/router'
import NoSSR from '../../../components/NoSSR';

const PageEditor = React.lazy(() => import('../../../components/PageEditor'));

function Page() {
  const router = useRouter();
  const {id} = router.query;

  return (
    <NoSSR>
      <React.Suspense fallback={<div>Loading...</div>}>
        <PageEditor id={id} />
      </React.Suspense>
    </NoSSR>
  );
};

export default Page;
