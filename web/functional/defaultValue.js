import * as R from 'ramda';
import notExist from './notExist';
import evalOrGet from './evalOrGet';

const valueTo = R.curry((v, p) => R.ifElse(notExist, () => evalOrGet(v), R.identity)(p));
const lensValueTo = R.curry((v, lens, o) => R.pipe(R.view(lens), valueTo(v))(o));
const valuePassby = (v, f) => R.ifElse(notExist, () => evalOrGet(v), f);
export {
  valueTo,
  lensValueTo,
  valuePassby,
};
