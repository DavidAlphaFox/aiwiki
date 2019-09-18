import React from 'react';
import Editor from 'for-editor';
import logo from './logo.svg';
import './App.css';

function App() {
  const title = 'XMPP';
  const [content, setContent] = React.useState('');
  return (
    <div className="section">
      <div className="columns">
        <div className="column is-one-fifth">
        </div>
        <div className="column">
          <div className="field">
            <label className="label">
              文章标题
        </label>
            <div className="control">
              <input
                className="input"
                value={title} />
            </div>
          </div>
          <div className="field">
            <label className="label">
              文章内容
        </label>
            <div className="control">
              <Editor
                height="500px"
                toolbar={{
                  preview: true
                }}
                onChange={value => setContent(value)}
                value={content}
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
