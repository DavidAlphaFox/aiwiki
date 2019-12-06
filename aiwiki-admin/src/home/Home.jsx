import React from 'react';
import {Route} from 'react-router';
import PageEditor from '../page/PageEditor';
function Home(){
  return (
    <React.Fragment>
      <Route path='/admin/page/:id' component={PageEditor} exact />
    </React.Fragment>
  );
}

export default Home;
