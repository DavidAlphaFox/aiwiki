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
const updatePage = (pageID,page) => doRequest({
  method: 'POST',
  url: genPageUrl(pageID),
  headers: {
    'Content-Type': 'application/json'
  },
  data: JSON.stringify(page),
});

const createPage = (page) => doRequest({
  method: 'POST',
  url: pagesUrl,
  headers: {
    'Content-Type': 'application/json'
  },
  data: JSON.stringify(page),
});

export {
  getPages,
  getPage,
  updatePage,
  createPage,
};
