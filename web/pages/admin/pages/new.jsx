import React from 'react';
import { useRouter } from 'next/router'
import NoSSR from '../../../components/NoSSR';
import privateRoute from '../../../components/PrivateRoute';
const PageEditor = React.lazy(() => import('../../../components/PageEditor'));

function Page() {
  const router = useRouter();
  const {id} = router.query;

  return (
    <NoSSR>
      <React.Suspense fallback={<div>Loading...</div>}>
        <PageEditor />
      </React.Suspense>
    </NoSSR>
  );
};

export default privateRoute(Page);
