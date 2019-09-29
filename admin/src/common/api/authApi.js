import {
  doRequest,
} from './remoteApi';

const loginUrl = '/api/login.json';

const login = (data) => doRequest({
  method: 'POST',
  url: loginUrl,
  headers: {
    'Content-Type': 'application/json'
  },
  data: JSON.stringify(data),
});

export {
  login,
};
