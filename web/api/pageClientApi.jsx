import {doRequest} from './clientBaseApi';

import {
  pageAdminPath,
} from './serverUrl';


const fetchPageAdmin = (id) => doRequest({
  method: 'GET',
  url: `${pageAdminPath}/${id}`,
  headers: {
    'Content-Type': 'application/json',
  }
});

export {
  fetchPageAdmin,
};
