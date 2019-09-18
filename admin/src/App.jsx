import React from 'react';
import { Router, Route } from "react-router";
import { createBrowserHistory } from "history";

import Pages from './components/pages/Pages';
import Page from  './components/pages/Page';

function App() {
  const history = createBrowserHistory()
  return (
    <Router history={history}>
      <Route path="/admin/pages/:id" component={Page} exact />
      <Route path="/admin/pages" component={Pages} exact />
    </Router>
  );
}

export default App;
