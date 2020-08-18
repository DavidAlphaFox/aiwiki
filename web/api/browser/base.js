import axios from 'axios';
import Cookie from 'js-cookie'
import { Subject } from 'rxjs';
import * as RxOp from 'rxjs/operators';
import {
  apiHost,
} from '../../config';
import {
  COOKIE_NAME,
} from '../../services/authService';

const makeAxiosInstance = (axiosConfig) => {
  const instance = axios.create();
  instance.interceptors.request.use(function (config){
    /*if(config.url.startsWith('http://') || config.url.startsWith('https://')){
      return config;
    }*/
    const headers = config.headers || {};
    const token = Cookie.get(COOKIE_NAME);
    console.log(token);
    if (token !== undefined && token !== null) {
      headers['Authorization'] = 'Bearer ' + token;
    }
    config.headers = headers;
    return config;
  }, function (error){
    return Promise.reject(error);
  });
  return instance({...axiosConfig});
};

const  defaultPipe = event$ => event$.pipe(RxOp.map(res => res.data));

const doRequest = (axiosConfig, processor = defaultPipe) => {
  const response$ = new Subject();
  try {
    makeAxiosInstance(axiosConfig).then((response)=> {
      response$.next(response);
      response$.complete();
    }).catch(error => response$.error({
      remote: true,
      error,
    }));
  } catch (error) {
    response$.error({
      remote: false,
      error,
    });
  }
  if(processor !== undefined || processor !== null){
    return processor(response$);
  }
  return response$;
};


const authPath = apiHost('/api/auth');
const pageAdminPath = apiHost('/api/pages');
const topicAdminPath = apiHost('/api/topics');

export {
  defaultPipe,
  doRequest,
  authPath,
  pageAdminPath,
  topicAdminPath,
};
