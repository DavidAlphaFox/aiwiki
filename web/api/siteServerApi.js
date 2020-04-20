import fetch from 'node-fetch';
import * as R from 'ramda';
import {
  sitePath,
  headerPath,
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

export {
  fetchSite,
  fetchHeader,
};
