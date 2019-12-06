import React from 'react'
import { Provider } from 'react-redux';
import { Router} from 'react-router';
import { createBrowserHistory } from 'history';
import { createReduxStore } from './store';
import PrivateRoute from './router/PrivateRoute';
import Home from './home/Home';

function App(){
  const history = createBrowserHistory();
  const store = createReduxStore();
  return (
    <Provider store={store}>
      <Router history={history}>
        <PrivateRoute path="/admin/" component={Home} />
      </Router>
    </Provider>
  );
}
export default App;
