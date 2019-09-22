import React from 'react';
import * as R from 'ramda';
import * as RxOp from 'rxjs/operators';
import { Link } from 'react-router-dom';
import { useSelector, useDispatch } from 'react-redux';

import {
  genHandleRemoteData,
  genHandlePagerAction,
} from '../../actions/pagesAction';

import {
  reduxSelect
} from '../../common/functional';

import {
  useObservable,
} from '../../common/hooks'

import {
  getPages,
} from '../../common/api';

import {
  Pager,
} from '../pager';

const propsPath = [
  ['pages', 'pageIndex'],
  ['pages', 'pageSize'],
  ['pages', 'total'],
  ['pages', 'pages'],
];

function Pages() {
  const dispatch = useDispatch();
  const [
    pageIndex,
    pageSize,
    total,
    pages,
  ] = reduxSelect(useSelector, propsPath);

  const handleRemoteData = genHandleRemoteData(dispatch);
  const handlePager = genHandlePagerAction(dispatch);

  const requestParams = useObservable(event$ => event$.pipe(
    RxOp.map(([pageIndex, pageSize]) => ({ pageIndex, pageSize }))
  ), [1, 10], [pageIndex, pageSize]);

  React.useEffect(() => {
    if (requestParams === null) return;
    getPages(requestParams).subscribe(res => handleRemoteData(res))
  }, [requestParams]);
  const renderTable = R.map((item) => (
    <tr key={R.prop('id', item)}>
      <td className="has-text-centered">{R.prop('id', item)}</td>
      <td className="has-text-centered">{R.prop('title', item)} </td>
      <td className="has-text-centered"><Link to={`/admin/pages/${R.prop('id', item)}`}> 编辑 </Link> </td>
    </tr>
  ));
  return (
    <div className="section">
      <div className="columns is-centered">
        <div className="column">
          <table className="table is-bordered is-fullwidth">
            <thead>
              <tr>
                <th className="has-text-centered">文章ID</th>
                <th className="has-text-centered">文章标题</th>
                <th className="has-text-centered">操作</th>
              </tr>
            </thead>
            <tbody>
              {renderTable(pages)}
            </tbody>
          </table>
        </div>
      </div>
      <div className="columns is-centered">
        <div className="column">
          <Pager
            total={total}
            pageIndex={pageIndex}
            pageSize={pageSize}
            goPrev={() => handlePager(-1)}
            goNext={() => handlePager(1)}
          />
        </div>
 
      </div>
    </div>

  );
}

export default Pages;
