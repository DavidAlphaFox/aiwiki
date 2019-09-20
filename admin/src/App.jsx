import React from 'react';
import { Provider } from 'react-redux';
import { Router, Route } from "react-router";
import { createBrowserHistory } from "history";
import store from './store';

import Pages from './components/pages/Pages';
import Page from './components/pages/Page';

function App() {
  const history = createBrowserHistory()
  return (
    <Provider store={store}>
      <Router history={history}>
        <Route path="/admin/pages/:id" component={Page} exact />
        <Route path="/admin/pages" component={Pages} exact />
      </Router>
    </Provider>
  );
}

export default App;
