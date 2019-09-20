import * as R from 'ramda';

const PAGES_INDEX_CHANGE = Symbol('PAGES_INDEX_CHANGE');
const pagesActionType = [PAGES_INDEX_CHANGE];

const pagesInitialState = {
  pageIndex: 1,
  pageSize: 10,
  total: 0,
  pages: [],
};

export {
  pagesActionType,
  pagesInitialState,
};
