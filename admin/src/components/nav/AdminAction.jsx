import React from 'react';
import { Link } from 'react-router-dom';

function AdminAction(props) {
  return(
    <div className="navbar-start">
      <Link className="navbar-item" to="/admin/site" > 管理站点 </Link>
      <Link className="navbar-item" to="/admin/pages" > 管理文章 </Link>
    </div>
  );
}
export default AdminAction;
