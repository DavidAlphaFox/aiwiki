import {
  doRequest,
} from './remoteApi';

const getPageUrl = '/api/pages/show.json';

const getPage = (pageID) => doRequest({
  method: 'GET',
  url: getPageUrl,
  params: {
    id: pageID
  }
});

export {
  getPage,
};