import React from 'react'

import * as R from 'ramda';
import BraftEditor from 'braft-editor'


import {
  fetchPageAdmin,
} from '../api';

function PageEditor(props){
  const { id } = props;
  const [editorState,setEditorState] = React.useState(BraftEditor.createEditorState(''));
  React.useEffect(() => {
    if(id === null || id === undefined){
      return;
    }
    fetchPageAdmin(id).subscribe(
      (res) => {
        const content = R.view(R.lensPath(['data','content']),res);
        console.log(content);
        const newEditorState = BraftEditor.createEditorState(content);
        setEditorState(newEditorState);
      }
    )
  },[id])
  return (
    <div className="p-8">
      <div className="content shadow-md rounded">
      <BraftEditor
        className="bg-white"
        value={editorState}
      />
      </div>

    </div>
  );
}
export default PageEditor;
