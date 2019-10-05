import React from 'react';
import clsx from 'clsx';
function SelectItem(props) {
  const {
    selected,
    onClick,
    children,
    other
  } = props;
  console.log(selected);
  return (
    <button
      {...other}
      className={clsx("button is-white dropdown-item",{'is-active': selected})}
      onClick={onClick}
    >
      {children}
    </button>
  );
}

export default SelectItem;
