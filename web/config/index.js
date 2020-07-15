const serverHost = (path) => {
 return `http://localhost:5000${path}`;
}

const apiHost = (path) => {
  return path;
}

export {
  serverHost,
  apiHost,
};
