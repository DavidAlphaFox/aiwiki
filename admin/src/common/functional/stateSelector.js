import * as R from 'ramda';

const genViewPath = R.pipe(R.lensPath, R.view);
const genPathSelector = R.cond([
  [R.pipe(R.head, R.is(String)), genViewPath],
  [R.T, R.map(genViewPath)],
]);

const genPropSelectors = R.cond([
  [R.is(Function), selector => f => f(selector)],
  [R.T, selectors => f => R.reduce((acc, selector) => R.append(f(selector), acc), [], selectors)],
]);

const genReduxSelector = R.pipe( genPathSelector, genPropSelectors);
const reduxSelect = (selectFn, propsPath) => genReduxSelector(propsPath)(selectFn);

export {
  reduxSelect,
  genReduxSelector,
};
