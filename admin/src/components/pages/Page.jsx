import React from 'react';
import * as R from 'ramda';
import { Link } from 'react-router-dom';
import Editor from 'for-editor';

import {
  actionReducer,
} from '../../common/functional';

import {
  getPage,
  updatePage,
} from '../../common/api';

import {
  Navbar,
} from '../nav';

import './Page.scss';

const initialState = {
  page: {
    id: '',
    title: '',
    intro: '',
    published: false,
    content: '',
  },
  commited: null,
  loading: false,
};

const pageLens = R.lensProp('page');
const loadingLens = R.lensProp('loading');
const commitedLens = R.lensProp('commited');

const genHandleRemoteData = R.curry((dispatch, data) => dispatch(
  R.pipe(
    R.set(pageLens, data),
    R.set(loadingLens, false)
  )));
const genStartLoading = dispatch => () => dispatch(R.set(loadingLens, true));
const genHandleField = R.curry((dispatch,field,data) => dispatch(
  R.set(R.lensPath(['page',field]), data)
));
const genHandleCommit = dispatch => () => dispatch(s => R.set(commitedLens,R.view(pageLens,s),s));

function Page(props) {
  const {
    match: { params }
  } = props;
  const [state, dispatch] = React.useReducer(actionReducer, initialState);

  const handleRemoteData = genHandleRemoteData(dispatch);
  const startLoading = genStartLoading(dispatch);
  const handleField = genHandleField(dispatch);
  const handleCommit = genHandleCommit(dispatch);
  React.useEffect(() => {
    if (params === null || params === undefined) return;
    startLoading();
    getPage(params.id).subscribe(res => handleRemoteData(res));
  }, [params]);
  React.useEffect(() => {
    const commited = R.view(commitedLens,state);
    if(commited === null) return;
    startLoading();
    updatePage(commited.id,commited).subscribe(res => handleRemoteData(res));
  },[state.commited])
  const renderNav = () => {
    const {
      loading,
      page,
    } = state;
    if (loading) {
       return null;
    }
    return (
      <div className="navbar-end">
        <div class="navbar-item">
          <div class="buttons">
            <button
              className="button is-primary"
              onClick={e => handleCommit()}
            >
              { page.published ? '保存更改' : '存为草稿'}
            </button>
            <button
              className="button is-light"
              onClick={e => handleField('published', !page.published)}
            >
              { page.published ? '取消发布' : '发布'}
            </button>
          </div>
        </div>
      </div>
    );
  };
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
            <input
              className="input"
              type="text"
              placeholder="文章标题"
              onChange={e => handleField('title',e.target.value) }
              value={page.title}
            />
          </div>
        </div>
        <div className="field">
          <label className="label">文章简介</label>
          <div className="control markdown">
            <textarea
              rows="3"
              className="textarea"
              type="text"
              placeholder="文章简介"
              onChange={e => handleField('intro',e.target.value)}
              value={page.intro} />
          </div>
        </div>
        <div className="field" >
          <label className="label">文章内容</label>
          <div className="control markdown">
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
              onChange={val => handleField('content',val)}
              value={page.content}
            />
          </div>
        </div>
      </div>
    );
  };

  return (
    <div>
      <Navbar>
        <div className="navbar-start">
          <Link className="navbar-item" to="/admin/pages" > 返回总览 </Link>
        </div>
        {renderNav()}
      </Navbar>
      <div className="section">
        {renderPage()}
      </div>
    </div>
  );
}
export default Page;
