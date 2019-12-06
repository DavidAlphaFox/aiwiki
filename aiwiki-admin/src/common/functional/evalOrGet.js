import * as R from 'ramda';
export default R.ifElse(R.is(Function), fun => fun(), R.identity);
