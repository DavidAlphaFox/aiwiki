import React from 'react';
import Link from 'next/link'
import clsx from 'clsx';
import * as urlParse from 'url-parse';
import queryString from 'query-string';

import * as R from 'ramda';

const buildUrl = (url, index, size) => {
  const theUrl = urlParse(url);
  const theQuery = theUrl.query || {};
  const query = queryString.stringify({
    ...theQuery,
    index,
    size,
  });
  return theUrl.pathname + "?" + query;
};
function Pager(props) {
  const {
    className,
    total,
    index,
    size,
    url
  } = props;
  const havingPrev = React.useMemo(() => R.lt(0, index), [index]);
  const havingNext = React.useMemo(
    () => R.gte(total, (index + 1) * size),
    [index, size, total]);
  const offset = React.useMemo(
    () => {
      const pageOffset = (index + 1 ) * size;
      if(pageOffset > total) {
        return total;
      }
      return pageOffset
    }, [size,total]);

  return (
    <div className={className}>
      <div className="flex w-auto">
        <a
          href={havingPrev ? buildUrl(url, index - 1, size) : null}
          className={clsx('w-32 font-bold py-2 mx-2 text-center focus:outline-none', {
            'text-teal-500': havingPrev,
            'hover:text-teal-700': havingPrev,
            'text-gray-500': !havingPrev,
          })}>
          上一页
        </a>
        <div className="py-2">
          <span>
            {`${offset}/${total}`}
          </span>
        </div>
        <a
          href={havingNext ? buildUrl(url, index + 1, size): null}
          className={clsx('w-32 font-bold py-2 mx-2 text-center focus:outline-none', {
            'text-teal-500': havingNext,
            'hover:text-teal-700': havingNext,
            'text-gray-500': !havingNext,
          })}
        >
          下一页
        </a>
      </div>
    </div>
  )

}

export default Pager;
