import {
  doRequest,
} from './remoteApi';

const getTokenUrl = '/api/auth/token.json';

const getPage = () => doRequest({
  method: 'GET',
  url: getTokenUrl,
  withCredentials: true,
  withoutBearer: true,
});

export {
  getPage,
};
