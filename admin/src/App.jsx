import React from 'react';
import { Provider } from 'react-redux';
import { Router, Route } from "react-router";
import { createBrowserHistory } from "history";
import store from './store';

import PrivateRoute from './components/routers/PrivateRoute';
import Pages from './components/pages/Pages';
import Page from './components/pages/Page';
import Login from './components/auth/Login';

function App() {
  const history = createBrowserHistory()
  return (
    <Provider store={store}>
      <Router history={history}>
        <PrivateRoute path="/admin/pages/:id" component={Page} exact />
        <PrivateRoute path="/admin/pages" component={Pages} exact />
        <Route path="/admin/login" component={Login} exact/>
      </Router>
    </Provider>
  );
}

export default App;
