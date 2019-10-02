import {
    doRequest,
  } from './remoteApi';
  
  const siteUrl = '/api/site.json';
  
  const getSiteInfo = () => doRequest({
    method: 'GET',
    url: siteUrl,
    headers: {
      'Content-Type': 'application/json'
    },
  });
  const updateSiteInfo = (siteInfo) => doRequest({
    method: 'POST',
    url: siteUrl,
    headers: {
      'Content-Type': 'application/json'
    },
    data: JSON.stringify(siteInfo),
  });

  export {
    getSiteInfo,
    updateSiteInfo,
  };
  