import React from 'react';
import ReactDOM from 'react-dom';
import App from './App.jsx';
import '../css/styles.css';
const pageIDElement = document.getElementById('page-id');
console.log(pageIDElement);
if(pageIDElement === null || pageIDElement === undefined){
  ReactDOM.render(<App />, document.getElementById('root'));
} else {
  const pageID = pageIDElement.getAttribute("data-page-id");
  console.log(pageID);
  ReactDOM.render(<App pageID={pageID} />, document.getElementById('root'));
}
