import React from 'react'
import * as R from 'ramda';
import {useParams } from 'react-router';
import BraftEditor from 'braft-editor'
import 'braft-editor/dist/index.css'

import {
  getPage
} from '../common/api';

function PageEditor(props){
  const {id} = useParams();
  const [editorState,setEditorState] = React.useState(BraftEditor.createEditorState(''));
  React.useEffect(() => {
    if(id === null || id === undefined){
      return;
    }
    getPage(id).subscribe(
      (res) => {
        const content = R.view(R.lensPath(['data','content']),res);
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
