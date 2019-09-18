import * as R from 'ramda';
import notExsist from './notExsist';
import evalOrGet from './evalOrGet';

const valueTo = R.curry((v, p) => R.ifElse(notExsist, () => evalOrGet(v), R.identity)(p));
const lensValueTo = R.curry((v, lens, o) => R.pipe(R.view(lens), valueTo(v))(o));
export {
  valueTo,
  lensValueTo,
};
