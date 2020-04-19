import fetch from 'node-fetch';
import {
  sitePath,
  headerPath,
} from './serverUrl';

const fetchSite = () =>{
  return fetch(sitePath)
    .then(res => res.json())
    .then((payload) => {
      return {
        brand: payload.brand,
        footer: payload.footer,
      };
    })
    .catch(() => null);
};
const fetchHeader = () => {
  return fetch(headerPath)
    .then(res => res.json())
    .then((payload) => {
      return {
        header: payload.data
      };
    })
    .catch(() => null);
};

export {
  fetchSite,
  fetchHeader,
};
