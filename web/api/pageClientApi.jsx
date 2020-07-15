import {doRequest} from './clientBaseApi';

import {
  pageAdminPath,
  topicAdminPath,
} from './serverUrl';


const fetchPageAdmin = (id) => doRequest({
  method: 'GET',
  url: `${pageAdminPath}/${id}`,
  headers: {
    'Content-Type': 'application/json',
  }
});

const fetchTopicAdmin = () => doRequest({
  method: 'GET',
  url: topicAdminPath,
  headers: {
    'Content-Type': 'application/json',
  }
});

export {
  fetchPageAdmin,
  fetchTopicAdmin,
};
