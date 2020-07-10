import fetch from 'node-fetch';
import * as R from 'ramda';
import {
  pagePath,
  topicPath,
} from './serverUrl';

const defaultIndexPage = {
  pages: [],
  topics: [],
  index: 0,
  size: 5,
  total: 0,
};

const fetchIndexPage = (query) => {
  const pageUrl = new URL(pagePath);
  const topicUrl = new URL(topicPath);
  R.mapObjIndexed((v,k,o) => pageUrl.searchParams.append(k,v),query);
  const pageReq = fetch(pageUrl);
  const topicReq = fetch(topicUrl);
  return Promise.all([pageReq,topicReq])
               .then(([pageRes,topicRes]) => {
                 return Promise.all([pageRes.json(),topicRes.json()]);
               })
               .then(([pages,topics]) => {
                 return {
                   pages: pages.data,
                   total: pages.total,
                   index: pages.index,
                   size: pages.size,
                   topics: topics.data
                 };
               })
               .catch(() => defaultIndexPage);
};

const fetchPage = (id)=> {
  const url = `${pagePath}/${id}`;
  return fetch(url)
    .then(res => res.json())
    .then(R.prop('data'))
    .catch(() => null);
};

export {
  fetchIndexPage,
  fetchPage,
};
