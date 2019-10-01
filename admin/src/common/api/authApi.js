import {
  doRequest,
} from './remoteApi';

const loginUrl = '/api/login.json';
const verifyTokenUrl = '/api/token/verify.json';

const login = (data) => doRequest({
  method: 'POST',
  url: loginUrl,
  headers: {
    'Content-Type': 'application/json'
  },
  data: JSON.stringify(data),
});
const verifyToken = () => doRequest({
  method: 'GET',
  url: verifyTokenUrl,
  headers: {
    'Content-Type': 'application/json'
  },
});

export {
  login,
  verifyToken,
};
