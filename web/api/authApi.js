import axios, { AxiosRequestConfig } from "axios";
import {
  authPath,
} from './serverUrl';

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
