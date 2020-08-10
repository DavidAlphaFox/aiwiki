import {
  doRequest,
  authPath,
} from './base.js';

const auth = data =>  doRequest({
  method: 'PUT',
  url: authPath,
  headers: {
    'Content-Type': 'application/json',
  },
  data: JSON.stringify(data),
});
export {
  auth,
};
