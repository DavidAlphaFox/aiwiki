import React from 'react';
import * as R from 'ramda';
import { Link } from 'react-router-dom';
import Editor from 'for-editor';
import {
  actionReducer,
} from '../../common/functional';

import {
  getPage,
} from '../../common/api';

const initialState = {
  page: {
    id: '',
    title: '',
    intro: '',
    published: false,
    content: '',
  },
  loading: false,
};

const genHandleRemoteData = R.curry((dispatch, data) => dispatch(
  R.pipe(
    R.set(R.lensProp('page'), data),
    R.set(R.lensProp('loading'), false)
  )));
const genStartLoading = dispatch => () => dispatch(R.set(R.lensProp('loading'), true));

function Page(props) {
  const {
    match: { params }
  } = props;
  const [state, dispatch] = React.useReducer(actionReducer, initialState);

  const handleRemoteData = genHandleRemoteData(dispatch);
  const startLoading = genStartLoading(dispatch);
  React.useEffect(() => {
    if (params === null || params === undefined) return;
    startLoading();
    getPage(params.id).subscribe(res => handleRemoteData(res));
  }, [params]);

  const renderPage = () => {
    const {
      loading,
      page,
    } = state;
    if (loading) {
      return (<progress className="progress is-small is-primary" max="100">15%</progress>);
    }

    return (
      <div className="column">
        <div className="field">
          <label className="label">文章标题</label>
          <div className="control">
            <input className="input" type="text" placeholder="文章标题" value={page.title} />
          </div>
        </div>
        <div className="field">
          <label className="label">文章简介</label>
          <div className="control">
            <textarea rows="3" className="textarea" type="text" placeholder="文章简介" value={page.intro} />
          </div>
        </div>
        <div className="field" >
          <label className="label">文章内容</label>
          <div className="control">
            <Editor
              toolbar={{
                preview: true,
                h1: true, // h1
                h2: true, // h2
                h3: true, // h3
                h4: true, // h4
                img: true, // 图片
                link: true, // 链接
                code: true, // 代码块p
              }}
              onChange={(val) => val}
              value={page.content}
            />
          </div>
        </div>
        <div className="filed ">
          <div className="control">
            <label className="checkbox">
              <input type="checkbox" value={page.published} />
              发布
            </label>
          </div>
        </div>
      </div>
    );
  };

  return (
    <div>
      <nav className="navbar has-shadow" role="navigation" aria-label="main navigation">
        <div className="navbar-menu">
          <Link className="navbar-item" to="/admin/pages" >
            返回总览
        </Link>
        </div>
      </nav>
      <div className="section">
        {renderPage()}
      </div>
    </div>
  );
}
export default Page;
