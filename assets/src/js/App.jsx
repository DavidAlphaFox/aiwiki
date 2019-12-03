import React from 'react'
import * as R from 'ramda';
import BraftEditor from 'braft-editor'
import 'braft-editor/dist/index.css'

import {
  getPage
} from './pageApi';

function App(props){
  const {
    pageID
  } = props;
  const [editorState,setEditorState] = React.useState(BraftEditor.createEditorState(''));
  React.useEffect(() => {
    if(pageID === null || pageID === undefined){
      return;
    }
    getPage(pageID).subscribe(
      (res) => {
        const content = R.view(R.lensPath(['data','content']),res);
        const newEditorState = BraftEditor.createEditorState(content);
        setEditorState(newEditorState);
      }
    )
  },[pageID])
  return (
    <div className="p-8">
      <div className="editor-content shadow-md rounded">
      <BraftEditor
        className="bg-white"
        value={editorState}
      />
      </div>

    </div>
  );
}
export default App;