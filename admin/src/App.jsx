import React from 'react';
import { Provider } from 'react-redux';
import { Router, Route } from "react-router";
import { createBrowserHistory } from "history";
import { createReduxStore } from './store';

import PrivateRoute from './components/routers/PrivateRoute';
import AdminIndex from './components/AdminIndex';
import Pages from './components/pages/Pages';
import Page from './components/pages/Page';
import SiteInfo from './components/site/SiteInfo';
import Login from './components/auth/Login';

function App(props) {
  const {state} = props;
  const history = createBrowserHistory();
  const store = createReduxStore(state);
  return (
    <Provider store={store}>
      <Router history={history}>
        <PrivateRoute path="/admin/pages/:id" component={Page} exact />
        <PrivateRoute path="/admin/pages" component={Pages} exact />
        <PrivateRoute path="/admin/site" component={SiteInfo} exact />
        <PrivateRoute path="/admin/index" component={AdminIndex} exact />
        <PrivateRoute path="/admin" component={AdminIndex} exact />
        <Route path="/admin/login" component={Login} exact/>
      </Router>
    </Provider>
  );
}

export default App;
