import React from 'react';

function Dropdown(props) {
  const {
    anchorEl,
    children: childrenProp,
    transformContent = {
      top: 0,
      left: 0,
    },
  } = props;
  const children = React.Children.toArray(childrenProp);
  const [element,setElement] = React.useState(null);
  const getAnchorOffset = React.useCallback(() => {
    const anchorRect = anchorEl.getBoundingClientRect();
    return {
      top: anchorRect.top + anchorRect.height +  (transformContent.top ? transformContent.top : 0),
      left: anchorRect.left + (transformContent.left ? transformContent.left : 0),
    };
  },[anchorEl]);
  React.useEffect(() => {
    if(element === null) return;
    if(null === anchorEl || undefined === anchorEl) return;
    const positioning = getAnchorOffset();
    element.style.zIndex = 1000;
    element.style.position = 'absolute';
    if (positioning.top !== null) {
      element.style.top = positioning.top + 'px';
    }
    if (positioning.left !== null) {
      element.style.left = positioning.left + 'px';
    }
  },[anchorEl,element,getAnchorOffset]);
  if(anchorEl === null) {
    return null;
  }
  return (
    <div ref={setElement}>
      {children}
    </div>
  );
}

export default Dropdown;
