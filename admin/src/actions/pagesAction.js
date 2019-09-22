import * as R from 'ramda';

const PAGES_INDEX_CHANGE = Symbol('PAGES_INDEX_CHANGE');
const PAGES_REMOTE_DATA = Symbol('PAGES_REMOTE_DATA');
const pagesActionType = [PAGES_INDEX_CHANGE, PAGES_REMOTE_DATA];

const pagesInitialState = {
  pageIndex: 1,
  pageSize: 10,
  total: 0,
  pages: [],
};


const genHandleRemoteData = R.curry((dispatch, data) => dispatch({
  type: PAGES_REMOTE_DATA,
  f: R.mergeLeft(R.pick(['total', 'pages'], data))
}));
const genHandlePagerAction = R.curry((dispatch, incr) => dispatch({
  type: PAGES_INDEX_CHANGE,
  f: R.over(R.lensProp('pageIndex'), s => s + incr)
}));

export {
  pagesActionType,
  pagesInitialState,
  genHandleRemoteData,
  genHandlePagerAction,
};
