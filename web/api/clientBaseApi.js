import axios from 'axios';
import Cookie from 'js-cookie'l
import { Subject } from 'rxjs';
import * as RxOp from 'rxjs/operators';

const makeAxiosInstance = (axiosConfig) => {
  const instance = axios.create();
  instance.interceptors.request.use(function (config){
    if(config.url.startsWith('http://') || config.url.startsWith('https://')){
      return config;
    }
    const headers = config.headers || {};
    const token = Cookie.get('aiwiki.authToken');
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

export {
  defaultPipe,
  doRequest,
};
