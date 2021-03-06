import {
  serverHost
} from '../../config';

const pagePath = serverHost('/api/pages');
const topicPath = serverHost('/api/topics');
const sitePath = serverHost('/api/sites/site');
const headerPath = serverHost('/api/sites/header');
const sidebarPath = serverHost('/api/sites/sidebar');

export {
  pagePath,
  topicPath,
  sitePath,
  headerPath,
  sidebarPath
};
