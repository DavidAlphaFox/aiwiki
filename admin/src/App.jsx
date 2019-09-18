import React from 'react';

import { Router, Route } from "react-router";
import { createBrowserHistory } from "history";




import Pages from './components/pages/Pages';

function App() {
  const history = createBrowserHistory()
  return (
    <Router history={history}>
      <Route path="/admin/pages" component={Pages} />
    </Router>
  );
}

export default App;
