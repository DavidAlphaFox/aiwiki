import React from 'react';
import Link from 'next/link';
import * as R from 'ramda';
import moment from 'moment';

function PageIndex(props){
  const {
    pages,
  } = props;
  const renderPage = R.map((p) => {
    const url = `/pages/${p.id}`;
    return (
      <li className="mt-6" key={p.id}>
        <div className="text-left">
          <div className="flex items-end mb-4">
          <Link href="/pages/[id]" as={url}>
            <a target="_blank">
              <h2 className="text-xl font-bold"> {p.title }</h2>
            </a>
          </Link>
          <span className="mx-4 font-xs">
            {moment(p.publishedAt).format("YYYY-MM-DD")}
          </span>
          </div>
          <div className="text-gray-600">
            { p.intro }
            <Link href="/pages/[id]" as={url}>
              <a className="text-indigo-500" target="_blank">
                阅读更多...
              </a>
            </Link>
          </div>
        </div>
      </li>
    );
  });
  
  return (
    <ul className="pb-4 md:mx-4">
      {renderPage(pages)}
    </ul>
  );
}

export default PageIndex;
