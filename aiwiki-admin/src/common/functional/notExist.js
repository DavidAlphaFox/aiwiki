import * as R from 'ramda';

export default R.either(R.isNil, R.isEmpty);
