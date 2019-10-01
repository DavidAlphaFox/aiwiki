import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import {
  verifyToken,
} from './common/api';
import {
  createState,
} from './store';
import * as serviceWorker from './serviceWorker';

verifyToken().subscribe(
  (res) => {
    console.log(res);
    const state = createState(res.token);
    ReactDOM.render(<App state={state}/>, document.getElementById('root'));
  },
  (error) => {
    console.log(error);
    const state = createState(null);
    ReactDOM.render(<App state={state} />, document.getElementById('root'));
  }
);


// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
