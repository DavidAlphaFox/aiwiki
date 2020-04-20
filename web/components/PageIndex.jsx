import React from 'react';
import * as R from 'ramda';

function PageIndex(props){
  const {
    pages,
  } = props;
  const renderPage = R.map((p) => {
    return (
      <li className="mt-6" key={p.id}>
        <div className="text-left">
          <a href={`/pages/${p.id}`} target="_blank">
            <h2 className="mb-4 text-lg font-bold"> {p.title }</h2>
          </a>
          <div className="text-gray-600">
            { p.intro }
            <a className="text-teal-500" href={`/pages/${p.id}`} target="_blank">阅读更多...</a>
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
