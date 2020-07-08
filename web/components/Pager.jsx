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
  const havingNext = React.useMemo(() => R.gte(total, (index + 1) * size),
                                   [index, size, total]);
  const offset = React.useMemo(() => {
      const pageOffset = (index + 1 ) * size;
      if(pageOffset > total) {
        return total;
      }
      return pageOffset
    }, [size,index,total]);
  const nextUrl = React.useMemo(() => buildUrl(url, index + 1, size),[url,index,size]);
  const prevUrl = React.useMemo(() => buildUrl(url, index - 1, size),[url,index,size]);
  const renderPrevButton = () => {
    if(havingPrev){
      return (
        <Link href={prevUrl}>
          <a className="w-32 font-bold py-2 mx-2 text-center focus:outline-none text-teal-500 hover:text-teal-700"
          >
            上一页
          </a>
        </Link>
      );
    }
    return (
      <div className="w-32 font-bold py-2 mx-2 text-center focus:outline-none text-gray-500">
        <span>上一页</span>
      </div>
    )
  };
  const renderNextButton = () => {
    if(havingNext){
      return (
        <Link href={nextUrl}>
          <a className="w-32 font-bold py-2 mx-2 text-center focus:outline-none text-teal-500 hover:text-teal-700"
          >
            下一页
          </a>
        </Link>
      );
    }
    return (
      <div className="w-32 font-bold py-2 mx-2 text-center focus:outline-none text-gray-500">
        <span>下一页</span>
      </div>
    )
  };
  return (
    <div className={className}>
      <div className="flex w-auto">
        {renderPrevButton()}
        <div className="py-2">
          <span>
            {`${offset}/${total}`}
          </span>
        </div>
        {renderNextButton()}
      </div>
    </div>
  )

}

export default Pager;
