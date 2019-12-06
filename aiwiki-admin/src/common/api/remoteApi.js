import axios from 'axios';
import { Subject } from 'rxjs';
import * as RxOp from 'rxjs/operators';

const makeAxiosInstance = (axiosConfig) => {
  const instance = axios.create();
  instance.interceptors.request.use(function (config){
    const headers = config.headers || {};
    const token = sessionStorage.getItem('token');
    if (
      token !== undefined
        && token !== null
        && (config.withoutBearer === undefined
            || config.withoutBearer === null
            || config.withoutBearer === false)
        && (headers.Authorization === undefined
            || headers.Authorization === null)
       ) {
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
