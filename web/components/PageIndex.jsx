import React from 'react';
import Link from 'next/link';
import * as R from 'ramda';

function PageIndex(props){
  const {
    pages,
  } = props;
  const renderPage = R.map((p) => {
    const url = `/pages/${p.id}`;
    return (
      <li className="mt-6" key={p.id}>
        <div className="text-left">
          <Link href="/pages/[id]" as={url}>
            <a target="_blank">
              <h2 className="mb-4 text-lg font-bold"> {p.title }</h2>
            </a>
          </Link>
          <div className="text-gray-600">
            { p.intro }
            <Link href="/pages/[id]" as={url}>
              <a className="text-teal-500" target="_blank">
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
