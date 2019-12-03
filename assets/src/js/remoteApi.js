import axios from 'axios';
import { Subject } from 'rxjs';
import * as RxOp from 'rxjs/operators';

const makeAxiosInstance = (axiosConfig) => {
  const instance = axios.create();
  return instance({...axiosConfig,withCredentials: true});
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