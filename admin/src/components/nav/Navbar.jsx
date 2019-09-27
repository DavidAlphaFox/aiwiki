import React from 'react';
import clsx from 'clsx';

function Navbar(props) {
  const {
    children: childrenProp,
    shadow = true,
    fixed = true,
  } = props;
  const children = React.Children.toArray(childrenProp);
  return (
    <nav
      className={clsx("navbar", {
        'has-shadow': shadow,
        'is-fixed-top': fixed,
      })}
      role="navigation"
      aria-label="main navigation"
    >
      <div className="navbar-menu">
        {children}
      </div>
    </nav>
  );
}
export default Navbar;
