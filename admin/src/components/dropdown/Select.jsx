import React from 'react';
import clsx from 'clsx';
import * as R from 'ramda';

const isEqualValues = (a, b) => {
  if (typeof b === 'object' && b !== null) {
    return a === b;
  }
  return String(a) === String(b);
};

const isEmpty = display => (display == null || (typeof display === 'string' && !display.trim()));

function Select(props){
  const {
    children,
    multiple,
    right,
    disabled,
    value,
    renderValue,
    displayEmpty=true,
    onOpen,
    onClose,
    onChange,
  } = props;
  const [openState, setOpenState] = React.useState(false);

  const update = (open, event) => {
    if (open) {
      if (onOpen) {
        onOpen(event);
      }
    } else {
      if (onClose) {
        onClose(event);
      }
    }
    setOpenState(open);
  };
  const handleClick = event => {
    update(!openState,event);
  };
  const handleItemClick = child => event => {
    if (!multiple) {
      update(false, event);
    }

    if (onChange) {
      let newValue;

      if (multiple) {
        newValue = Array.isArray(value) ? [...value] : [];
        const itemIndex = value.indexOf(child.props.value);
        if (itemIndex === -1) {
          newValue.push(child.props.value);
        } else {
          newValue.splice(itemIndex, 1);
        }
      } else {
        newValue = child.props.value;
      }
      event.persist();
      event.target = { value: newValue};
      onChange(event);
    }
  };


  let display;
  let displaySingle;
  const displayMultiple = [];
  let computeDisplay = false;
  let foundMatch = false;

  // No need to display any value if the field is empty.
  if (displayEmpty) {
    if (renderValue) {
      display = renderValue(value);
    } else {
      computeDisplay = true;
    }
  }

  const items = React.Children.map(children, child => {
    if (!React.isValidElement(child)) return null;
    let selected;

    if (multiple) {
      if (!Array.isArray(value)) {
        throw new Error( '`value` prop must be an array ');
      }
      selected = value.some(v => isEqualValues(v, child.props.value));
      if (selected && computeDisplay) {
        displayMultiple.push(child.props.children);
      }
    } else {
      selected = isEqualValues(value, child.props.value);
      if (selected && computeDisplay) {
        displaySingle = child.props.children;
      }
    }

    if (selected) {
      foundMatch = true;
    }

    return React.cloneElement(child, {
      onClick: handleItemClick(child),
      role: 'option',
      selected,
      value: undefined, // The value is most likely not a valid HTML attribute.
      'data-value': child.props.value, // Instead, we provide it as a data attribute.
    });
  });

  if (computeDisplay) {
    display = multiple ? displayMultiple.join(', ') : displaySingle;
  }

  return(
    <div
      className={clsx("dropdown",{
        'is-active': openState,
        'is-right': right,
      })}
    >
      <div className="dropdown-trigger">
        <button
          className="button"
          aria-haspopup="true"
          aria-controls="dropdown-menu"
          onClick={disabled ? null : handleClick}
        >
          <span>{display}</span>
          <span className="icon is-small">
            <i className="fas fa-angle-down" aria-hidden="true"></i>
          </span>
        </button>
      </div>
      <div className="dropdown-menu" id="dropdown-menu" role="menu">
        <div className="dropdown-content">
          {items}
        </div>
      </div>
    </div>
  );

}

export default Select;
