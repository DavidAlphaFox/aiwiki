import {
  doRequest,
} from './remoteApi';

const getTokenUrl = '/api/auth/token.json';

const getToken = () => doRequest({
  method: 'GET',
  url: getTokenUrl,
  withCredentials: true,
  withoutBearer: true,
});

export {
  getToken
};
