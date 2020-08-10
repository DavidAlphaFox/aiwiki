import React from 'react'
import Select from 'react-select';
import * as R from 'ramda';
import BraftEditor from 'braft-editor'


import {
  fetchPageAdmin,
  fetchTopicAdmin,
} from '../api/browser';

function PageEditor(props){
  const { id } = props;
  const [editorState,setEditorState] = React.useState(BraftEditor.createEditorState(''));
  const [page,setPage] = React.useState({});
  const [topics,setTopics] = React.useState({});
  React.useEffect(()=>{
    fetchTopicAdmin().subscribe(
      (res) => {
        setTopics(
          R.map((topic)=> {
            return {
              value: topic.id,
              label: topic.title
            }
          },res.data));
      });
  },[]);
  React.useEffect(() => {
    if(id === null || id === undefined){
      return;
    }
    fetchPageAdmin(id).subscribe(
      (res) => {
        const content = R.view(R.lensPath(['data','content']),res);
        const newEditorState = BraftEditor.createEditorState(content);
        setPage(res.data);
        setEditorState(newEditorState);
      }
    )
  },[id])
  return (
    <div className="flex flex-col p-8">
      <div className="my-4">
        <input
          className="border shadow rounded w-full py-2 px-3 label-color"
          value={page.title}
        />
      </div>
      <div className="my-4">
        <textarea
          className="border shadow rounded w-full py-2 px-3 label-color"
          value={page.intro}
        />
      </div>
      <div className="my-4 content shadow-md rounded">
      <BraftEditor
        className="bg-white"
        value={editorState}
      />
      </div>
      <div className="my-4 flex items-center">
        <input
          type="checkbox"
          className="border shadow rounded label-color"
          checked={page.published}
        />
        <span className="mx-2">发布</span>
      </div>
      <div className="my-4 flex items-center">
        <span >主题</span>
        <div className="w-32 mx-2">
          <Select
            defaultValue={R.find(i => i.value === page.topic,topics)}
            options={topics}
          />
        </div>
      </div>
    </div>
  );
}
export default PageEditor;
