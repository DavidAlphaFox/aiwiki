import React from 'react';
import * as R from 'ramda';
const allTopic = {
  title: '全部',
};
const topicUrl = (topic) => {
  if(topic.id === undefined) {
    return '/';
  }
  return `/topics/${topic.id}`;
}
function Topic(props){
  const {
    topics,
    selected,
  } = props;

  const renderTopics = R.map((i) => {
    if(selected === i.id){
      return (
        <li
          key={i.title}
          className="mx-4 my-2 topic-item-selected"
        >
          <a href={topicUrl(i)} className="topic-item-link">
            <span className="px-4 text-md">
              {i.title}
            </span>
          </a>
        </li>
      );
    }
    return (
      <li
        key={i.title}
        className="mx-4 my-2 topic-item"
      >
        <a  href={topicUrl(i)} className="topic-item-link" >
          <span className="px-4 text-md text-gray-800 hover:text-teal-500">
            {i.title}
          </span>
        </a>
      </li>
    )
  });
  
  return (
    <div className="w-full">
      <div className="px-4 py-2 border-b border-teal-200 md:border-none md:text-center">
        <span className="text-lg font-bold">分类</span>
      </div>
      <ul className="pb-4 pt-4 md:bg-white">
        {R.pipe(
          R.prepend(allTopic),
          renderTopics,
        )(topics)}
      </ul>
    </div>
  );
}
export default Topic;
