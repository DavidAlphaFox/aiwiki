import React from 'react';
import clsx from 'clsx';

function TextField(props){
  const {
    label,
    className,
    onChange,
    ...rest
  } = props;
  return (
    <div className="field">
      <label className="label">{label}</label>
      <div className={clsx("control",className)}>
        <textarea
          {...rest}
          className="textarea"
          onChange={e => onChange(e.target.value)}
        />
      </div>
    </div>
  );
}

export default TextField;
