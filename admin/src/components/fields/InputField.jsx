import React from 'react';
import clsx from 'clsx';

function InputField(props){
  const {
    label,
    className,
    onChange,
    ...rest
  } = props;
  const renderLabel = () => (label ? <label className="label">{label}</label> : null);
  return (
    <div className="field">
      {renderLabel()}
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
