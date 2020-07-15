import React from 'react';
import Link from 'next/link';
import * as R from 'ramda';

function Topic(props){
  const {
    topics,
    selected,
  } = props;

  const renderTopics = R.map((topic) => {
    if(selected === topic.id){
      return (
        <li
          key={topic.title}
          className="mx-4 my-2 topic-item-selected"
        >
          <Link href="/topics/[id]" as={`/topics/${topic.id}`}>
            <a className="topic-item-link">
              <span className="px-4 text-md">{topic.title}</span>
            </a>
          </Link>
        </li>);
    }
    return (
      <li
        key={topic.title}
        className="mx-4 my-2 topic-item"
      >
        <Link href="/topics/[id]" as={`/topics/${topic.id}`}>
          <a className="topic-item-link" >
            <span className="px-4 text-md hover:primary-color">
              {topic.title}
            </span>
          </a>
        </Link>
      </li>
    )
  });
  
  return (
    <div className="w-full">
      <div className="px-4 py-2 border-b border-indigo-200 md:border-none md:text-center">
        <span className="text-lg font-bold">分类</span>
      </div>
      <ul className="pb-4 pt-4 md:bg-white">
        {renderTopics(topics)}
      </ul>
    </div>
  );
}
export default Topic;
