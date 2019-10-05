import React from 'react';
import clsx from 'clsx';

function InputField(props){
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
        <input
          {...rest}
          className="input"
          onChange={e => onChange(e.target.value)}
        />
      </div>
    </div>
  );
}

export default InputField;
