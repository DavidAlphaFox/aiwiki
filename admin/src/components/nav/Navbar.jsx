import Rect from 'react';

function Navbar(props) {
  const { children: childrenProp, className } = props;
  const children = React.Children.toArray(childrenProp);
  return (
    <nav className="navbar has-shadow is-fixed-top" role="navigation" aria-label="main navigation">
      <div className="navbar-menu">
        {children}
      </div>
    </nav>
  );
}
export default Navbar;
