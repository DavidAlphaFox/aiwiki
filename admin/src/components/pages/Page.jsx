import React from 'react';
import clsx from 'clsx';
import * as R from 'ramda';
import * as Rx from 'rxjs';
import { Link, Redirect } from 'react-router-dom';
import Editor from 'for-editor';

import {
  actionReducer,
} from '../../common/functional';

import {
  getPage,
  updatePage,
  createPage,
  getTopics,
  getPages,
} from '../../common/api';

import {
  Navbar,
} from '../nav';
import {
  InputField,
  TextField,
} from '../fields';
import {
  Select,
  SelectItem,
} from '../dropdown';

import './Page.scss';


const initialState = {
  page: {
    id: null,
    title: '',
    intro: '',
    published: false,
    content: '',
    topicId: 1,
  },
  topics: [],
  commited: null,
  loading: false,
  error: false,
};

const pageLens = R.lensProp('page');
const topicsLens = R.lensProp('topics');
const loadingLens = R.lensProp('loading');
const commitedLens = R.lensProp('commited');
const errorLens = R.lensProp('error');

const genHandlePage = R.curry((dispatch, data) => dispatch(
  R.pipe(
    R.set(pageLens, data),
    R.set(errorLens, false),
  )));
const genHandleTopics = R.curry((dispatch, data) => dispatch(R.set(topicsLens, data)));
const genStartLoading = dispatch => () => dispatch(R.set(loadingLens, true));
const genStopLoading = dispatch => () => dispatch(R.set(loadingLens,false));
const genHandleError = dispatch => () => dispatch(
  R.pipe(
    R.set(errorLens, true),
    R.set(loadingLens, false),
    R.set(commitedLens, null),
  ));
const genHandleField = R.curry((dispatch, field, data) => dispatch(
  R.set(R.lensPath(['page', field]), data)
));
const genHandleCommit = dispatch => () => dispatch(s => R.set(commitedLens, R.view(pageLens, s), s));

function Page(props) {
  const {
    match: { params }
  } = props;
  const [state, dispatch] = React.useReducer(actionReducer, initialState);

  const handlePage = genHandlePage(dispatch);
  const handleTopics = genHandleTopics(dispatch);
  const startLoading = genStartLoading(dispatch);
  const stopLoading = genStopLoading(dispatch);
  const handleField = genHandleField(dispatch);
  const handleCommit = genHandleCommit(dispatch);
  const handleError = genHandleError(dispatch);

  React.useEffect(() => {
    if (params === null || params === undefined) return;
    if (params.id === 'new') {
      startLoading();
      getTopics().subscribe((topics) => {
        handleTopics(topics);
        stopLoading();
      })
      return;
    }
    startLoading();
    Rx.forkJoin([getPage(params.id),getTopics()])
      .subscribe(([page,topics]) => {
        handlePage(page);
        handleTopics(topics);
        stopLoading();
      });
  }, [params]);

  React.useEffect(() => {
    const commited = R.view(commitedLens, state);
    if (commited === null) return;
    startLoading();
    if (commited.id === null || commited.id === '') {
      createPage(commited).subscribe(
        res => handleField('id', res.id),
        () => handleError())
    } else {
      updatePage(commited.id, commited).subscribe(
        res => {
          handlePage(res);
        },
        () => handleError());
    }
  }, [state.commited])

  const renderTopics = () => R.map(
    i => (<SelectItem key={i.id} value={i.id}>{i.title} </SelectItem>),
    state.topics);
  const renderNav = () => {
    const {
      loading,
      page,
      error,
    } = state;
    return (
      <div className="navbar-end">
       <div className="navbar-item">
          <Select
            right={true}
            value={page.topicId}
            onChange={handleField('topicId')}
          >
            {renderTopics()}
          </Select>
        </div>
        <div className="navbar-item">
          <div className="buttons">
            <button
              disabled={loading}
              className={clsx("button", {
                'is-primary': !error,
                'is-danger': error,
              })}
              onClick={e => handleCommit()}
            >
              {page.published ? '保存更改' : '存为草稿'}
            </button>
            <button
              className="button is-light"
              disabled={loading || page.id === null || page.id === ''}
              onClick={e => handleField('published', !page.published)}
            >
              {page.published ? '取消发布' : '发布'}
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
      return (
        <div className="column">
          <progress className="progress is-small is-primary" max="100">15%</progress>
        </div>);
    }

    return (
      <div className="column">
        <InputField
          label="文章标题"
          type="text"
          placeholder="文章标题"
          value={page.title}
          onChange={handleField('title')}
        />
        <TextField
          label="文章简介"
          className="markdown"
          rows="3"
          type="text"
          placeholder="文章简介"
          value={page.intro}
          onChange={handleField('intro')}
        />
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
              onChange={val => handleField('content', val)}
              value={page.content}
            />
          </div>
        </div>
      </div>
    );
  };

  if (params.id === 'new' && (state.page.id !== null && state.page.id !== '')) {
    return (<Redirect to={`/admin/pages/${state.page.id}`} />);
  }

  return (
    <div>
      <Navbar>
        <div className="navbar-start">
          <Link className="navbar-item" to="/admin/pages" >所有文章</Link>
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
