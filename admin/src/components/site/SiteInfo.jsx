import React from 'react';
import * as R from 'ramda';
import { Link, Redirect } from 'react-router-dom';

import {
  actionReducer,
} from '../../common/functional';

import {
  getSiteInfo,
  updateSiteInfo,
} from '../../common/api';

import {
  Navbar,
  AdminAction,
} from '../nav';

const initialState = {
  siteInfo: null,
  commited: null,
  loading: false,
};


const siteInfoLens = R.lensProp('siteInfo');
const loadingLens = R.lensProp('loading');
const commitedLens = R.lensProp('commited');

const genHandleRemoteData = R.curry((dispatch, data) => dispatch(
  R.pipe(
    R.set(siteInfoLens, data),
    R.set(loadingLens, false)
  )));
const genStartLoading = dispatch => () => dispatch(R.set(loadingLens, true));
const genHandleField = R.curry((dispatch,field,data) => dispatch(
  R.set(R.lensPath(['siteInfo',field]), data)
));
const genHandleCommit = dispatch => () => dispatch(s => R.set(commitedLens,R.view(siteInfoLens,s),s));


function SiteInfo() {
  const [state, dispatch] = React.useReducer(actionReducer, initialState);

  const handleRemoteData = genHandleRemoteData(dispatch);
  const startLoading = genStartLoading(dispatch);
  const handleField = genHandleField(dispatch);
  const handleCommit = genHandleCommit(dispatch);

  React.useEffect(() => {
    startLoading();
    getSiteInfo().subscribe(res => handleRemoteData(res));
  }, []);
  React.useEffect(() => {
    const commited = R.view(commitedLens,state);
    if(commited === null) return;
    startLoading();
    updateSiteInfo(commited).subscribe(res => handleRemoteData(res));
  },[state.commited])
  const renderNav = () => {
    return (
      <div className="navbar-end">
        <div className="navbar-item">
          <button
            disabled={state.loading || state.siteInfo === null}
            className="button is-primary"
            onClick={e => handleCommit()}
          >
            保存
            </button>
        </div>
      </div>
    );
  };
  const renderSiteInfo = () => {
    const {
      loading,
      siteInfo,
    } = state;
    if (loading || siteInfo === null) {
      return (
        <div className="column">
          <progress className="progress is-small is-primary" max="100">15%</progress>
        </div>
      );
    }
    return (
      <div className="column">
        <div className="field">
          <label className="label">brand</label>
          <div className="control">
            <input
              className="input"
              type="text"
              placeholder="brand"
              onChange={e => handleField('brand',e.target.value) }
              value={siteInfo.brand}
            />
          </div>
        </div>
        <div className="field">
          <label className="label">介绍</label>
          <div className="control">
            <input
              className="input"
              type="text"
              placeholder="介绍"
              onChange={e => handleField('intro',e.target.value) }
              value={siteInfo.intro}
            />
          </div>
        </div>
        <div className="field">
          <label className="label">关键字</label>
          <div className="control">
            <input
              className="input"
              type="text"
              placeholder="关键字"
              onChange={e => handleField('keywords',e.target.value) }
              value={siteInfo.keywords}
            />
          </div>
        </div>
        <div className="field">
          <label className="label">header</label>
          <div className="control">
            <textarea
              rows="5"
              className="textarea"
              type="text"
              placeholder="header"
              onChange={e => handleField('header',e.target.value) }
              value={siteInfo.header}
            />
          </div>
        </div>
        <div className="field">
          <label className="label">footer</label>
          <div className="control">
            <textarea
              rows="5"
              className="textarea"
              type="text"
              placeholder="footer"
              onChange={e => handleField('footer',e.target.value) }
              value={siteInfo.footer}
            />
          </div>
        </div>
        <div className="field">
          <label className="label">utm source</label>
          <div className="control">
            <input
              className="input"
              type="text"
              placeholder="utm source"
              onChange={e => handleField('utmSource',e.target.value) }
              value={siteInfo.utmSource}
            />
          </div>
        </div>
        <div className="field">
          <label className="label">utm medium</label>
          <div className="control">
            <input
              className="input"
              type="text"
              placeholder="介绍"
              onChange={e => handleField('utmMedium',e.target.value) }
              value={siteInfo.utmMedium}
            />
          </div>
        </div>
        <div className="field">
          <label className="label">utm campaign</label>
          <div className="control">
            <input
              className="input"
              type="text"
              placeholder="utm campaign"
              onChange={e => handleField('utmCampaign',e.target.value) }
              value={siteInfo.utmCampaign}
            />
          </div>
        </div>
      </div>
    );
  };
  return (
    <div>
      <Navbar>
        <AdminAction />
        {renderNav()}
      </Navbar>
      <div className="section">
        {renderSiteInfo()}
      </div>
    </div>
  );

}
export default SiteInfo;
