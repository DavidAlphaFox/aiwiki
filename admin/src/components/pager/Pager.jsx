import React from 'react';

const hasGoNext = (pageIndex, pageSize, total) => (pageIndex * pageSize < total);
const hasGoPrev = pageIndex => pageIndex > 1;

function Pager(props) {
  const {
    pageIndex,
    pageSize,
    total,
    goPrev,
    goNext,
  } = props;

  const handleGoNext = () => {
    if (hasGoNext(pageIndex, pageSize, total)){
      goNext();
    }
  };
  const handleGoPrev = () => {
    if (hasGoPrev(pageIndex)) {
      goPrev();
    }
  };

  return (
    <div className="container">
      <nav className="pagination is-centered" role="navigation" aria-label="pagination">
        <a
          onClick={handleGoPrev}
          className="pagination-previous"
          disabled={!hasGoPrev(pageIndex)}
        >
          前一页
        </a>
        <a
          onClick={handleGoNext}
          className="pagination-next"
          disabled={!hasGoNext(pageIndex,pageSize,total)}
        >
          后一页
        </a>
      </nav>
    </div>
  );

}
export default Pager;
