import React from 'react';

function siteInfo() {
  return (
    <div className="flex flex-col p-8">
      <div className="my-4">
        <textarea
          className="border shadow rounded w-full py-2 px-3 label-color"
          className="border shadow rounded w-full py-2 px-3 label-color"
          value={page.title}
        />
      </div>
      <div className="my-4">
        <textarea
          className="border shadow rounded w-full py-2 px-3 label-color"
          value={page.intro}
        />
      </div>
    </div>
  );
}


export default siteInfo;
