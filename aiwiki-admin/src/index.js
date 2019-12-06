import React from 'react';
import ReactDOM from 'react-dom';
import './admin.css';
import {
  getToken,
} from './common/api';
import App from './App';

//import * as serviceWorker from './serviceWorker';

const token$  = getToken();

token$.subscribe(
  (res) => {
    sessionStorage.setItem('token',res.token);
    ReactDOM.render(<App />, document.getElementById('root'));
  },
  err => console.log(err)
);


// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
//serviceWorker.unregister();
