import {serverHost,apiHost} from '../config';

const pagePath = serverHost('/api/pages');
const topicPath = serverHost('/api/topics');
const sitePath = serverHost('/api/sites/site');
const headerPath = serverHost('/api/sites/header');
const sidebarPath = serverHost('/api/sites/sidebar');
const authPath = apiHost('/api/auth');

export {
  pagePath,
  topicPath,
  sitePath,
  headerPath,
  sidebarPath,
  authPath,
};
