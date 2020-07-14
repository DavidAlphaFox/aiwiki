import fetch from 'node-fetch';
import * as R from 'ramda';
import {
  sitePath,
  headerPath,
  sidebarPath,
} from './serverUrl';

const fetchSite = () =>{
  return fetch(sitePath)
    .then(res => res.json())
    .then(R.identity)
    .catch(() => null);
};
const fetchHeader = () => {
  return fetch(headerPath)
    .then(res => res.json())
    .then(R.identity)
    .catch(() => null);
};

const fetchSidebar = () => {
  return fetch(sidebarPath)
    .then(res => res.json())
    .then(R.identity)
    .catch(() => null);
};

export {
  fetchSite,
  fetchHeader,
  fetchSidebar,
};
