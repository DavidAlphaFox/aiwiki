import React from 'react';
import {Route} from 'react-router';
import PageEditor from '../page/PageEditor';
import DropdownMenu from '../components/DropdownMenu';

function Home(){
  const ref = React.useRef();
  
  return (
    <React.Fragment>
      <header className="border-b border-gray-200 flex justify-around">
        <DropdownMenu
          title="站点"
          items={
            [
              {title: '配置列表',url: '/admin/site'},
              {title: '新增配置',url: '/admin/site/new'},
            ]}
        />
        <div className="text-left py-1 px-2">
          <div>
            <span className="text-teal-500 text-xl">文章</span>
          </div>
        </div>
        <div className="text-left py-1 px-2">
          <div>
            <span className="text-teal-500 text-xl">友链</span>
          </div>
        </div>
      </header>

      <Route path='/admin/page/:id' component={PageEditor} exact />
    </React.Fragment>
  );
}

export default Home;
