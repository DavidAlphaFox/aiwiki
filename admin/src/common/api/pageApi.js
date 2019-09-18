import {
  doRequest,
} from './remoteApi';

const pagesUrl = '/api/pages.json';
const genPageUrl = (pageID) => `/api/pages/${pageID}.json`;

const getPages = (params) => doRequest({
  method: 'GET',
  url: pagesUrl,
  params,
  });

const getPage = (pageID) => doRequest({
  method: 'GET',
  url: genPageUrl(pageID),
});

export {
  getPages,
  getPage
};
