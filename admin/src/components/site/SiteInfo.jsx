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

import {
  InputField,
  TextField,
} from '../fields';

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
        <InputField
          label="brand"
          type="text"
          placeholder="brand"
          onChange={handleField('brand')}
          value={siteInfo.brand}
        />
        <InputField
          label="介绍"
          type="text"
          placeholder="介绍"
          onChange={e => handleField('intro') }
          value={siteInfo.intro}
        />
        <InputField
          label="关键字"
          type="text"
          placeholder="关键字"
          onChange={e => handleField('keywords') }
          value={siteInfo.keywords}
        />
        <TextField
          label="header"
          rows="5"
          type="text"
          placeholder="header"
          onChange={handleField('header') }
          value={siteInfo.header}
        />
        <TextField
          label="footer"
          rows="5"
          placeholder="footer"
          onChange={handleField('footer') }
          value={siteInfo.footer}
        />
        <InputField
          label="utm source"
          type="text"
          placeholder="utm source"
          onChange={handleField('utmSource') }
          value={siteInfo.utmSource}
        />
        <InputField
          label="utm medium"
          type="text"
          placeholder="utm medium"
          onChange={handleField('utmMedium') }
          value={siteInfo.utmMedium}
        />
        <InputField
          label="utm campaign"
          type="text"
          placeholder="utm campaign"
          onChange={handleField('utmCampaign') }
          value={siteInfo.utmCampaign}
        />
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
