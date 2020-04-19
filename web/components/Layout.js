import React from 'react';

export default ({ children }) => {
  return (
    <React.Fragment>

      { React.Children.toArray(children) }
    </React.Fragment>
  );
};
