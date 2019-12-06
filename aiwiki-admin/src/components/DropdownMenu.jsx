import React from 'react';
import * as R from 'ramda';
import Dropdown from './Dropdown';

function DropdownMenu(props) {
  const {
    title,
    items = [],
  } = props;
  const [elem,setElem] = React.useState(null);
  //const elem = React.useRef();
  const [anchorEl, setAnchorEl] = React.useState(null);
  const handleOpen = (event) => {
    if(elem === null) return;
    setAnchorEl(elem);
  };
  const handleClose = (event) => {
    setAnchorEl(null);
  };
  const renderElems = R.map(
    el => (
      <li key={el.title} className='my-2 mx-2 hover:text-teal-500 tab-menu'>
        <a href={el.url} className='tab-menu-link'>
          {el.title}
        </a>
      </li>));
  return(
    <div
      onMouseEnter={handleOpen}
      onMouseLeave={handleClose}
    >
      <div className="text-left py-1 px-2" ref={setElem}>
        <span className="text-teal-500 text-xl">{title}</span>
      </div>
      <Dropdown
        anchorEl={anchorEl}
      >
        <ul className='px-2 py-1 border border-solid border-gray-200 max-w-sm'>
          {renderElems(items)}
        </ul>
      </Dropdown>
    </div>
  )
}
export default DropdownMenu;
