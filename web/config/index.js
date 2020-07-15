import * as R from 'ramda';
const serverHost = (path) => {
 return `http://localhost:5000${path}`;
}

const apiHost = (path) => {
  const nodeEnv = process.env['NODE_ENV'];
  if(nodeEnv == 'development'){
    return `http://localhost:5000${path}`;
  }
  return path;
}

export {
  serverHost,
  apiHost,
};
