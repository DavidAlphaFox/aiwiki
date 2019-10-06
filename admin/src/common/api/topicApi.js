import {
    doRequest,
  } from './remoteApi';

const topicUrl = '/api/topics.json';
const getTopics = () =>  doRequest({
    method: 'GET',
    url: topicUrl,
    headers: {
      'Content-Type': 'application/json'
    },
  });

export {
  getTopics,
};
