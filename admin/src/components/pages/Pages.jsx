import React from 'react';
import * as R from 'ramda';
import * as RxOp from 'rxjs/operators';
import { Link } from 'react-router-dom';
import {
  getPages,
} from '../../common/api';

import {
  actionReducer,
} from '../../common/functional';

import {
  useObservable,
} from '../../common/hooks';

const initialState = {
  pageIndex: 1,
  pageSize: 10,
  total: 0,
  pages: [],
};

const canGoNext = state => {
  const total = R.prop('total', state);
  const fetched = R.prop('pageIndex', state) * R.prop('pageSize', state);
  return (fetched < total);
};

const canGoPrev = state => {
  const pageIndex = R.prop('pageIndex', state);
  return pageIndex <= 1;
};

const genHandleRemoteData = R.curry((dispatch, data) => dispatch(R.mergeLeft(
  R.pick(['total', 'pages'], data)
)));

const genHandlePagerAction = R.curry((dispatch, incr) => dispatch(
  R.over(R.lensProp('pageIndex'), s => s + incr)
));

function Pages() {
  const [state, dispatch] = React.useReducer(actionReducer, initialState);
  const handleRemoteData = genHandleRemoteData(dispatch);
  const handlePagerAction = genHandlePagerAction(dispatch);
  const requestParams = useObservable(event$ => event$.pipe(
    RxOp.map(([pageIndex, pageSize]) => ({ pageIndex, pageSize }))
  ), [1, 10], [state.pageIndex, state.pageSize]);
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
        <div className="column is-half">
          <table className="table is-bordered is-fullwidth">
            <thead>
              <tr>
                <th className="has-text-centered">文章ID</th>
                <th className="has-text-centered">文章标题</th>
                <th className="has-text-centered">操作</th>
              </tr>
            </thead>
            <tbody>
              {renderTable(state.pages)}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

export default Pages;
