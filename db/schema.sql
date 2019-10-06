CREATE TABLE IF NOT EXISTS pages (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  intro TEXT,
  content TEXT,
  topic_id BIGINT DEFAULT 1 NOT NULL,
  published BOOLEAN DEFAULT false,
  published_at TIMESTAMP WITHOUT TIME ZONE DEFAULT (now() AT TIME ZONE 'UTC')
);
CREATE UNIQUE INDEX pages_title_key ON pages(title);

CREATE TABLE IF NOT EXISTS tags (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(255),
  enabled BOOLEAN DEFAULT true
);
CREATE UNIQUE INDEX tags_title_key ON tags(title);

CREATE TABLE IF NOT EXISTS page_tags (
  id BIGSERIAL PRIMARY KEY,
  page_id BIGINT,
  tag_id BIGINT
);

CREATE UNIQUE INDEX page_tag_key on page_tags(page_id,tag_id);

CREATE TABLE IF NOT EXISTS links (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(255),
  summary TEXT,
  url TEXT,
  published_at TIMESTAMP WITHOUT TIME ZONE DEFAULT (now() AT TIME ZONE 'UTC')
);

CREATE UNIQUE INDEX links_title_key on links(title);
/*
  utm_source ttalk.im
  utm_campaign Tech Talk
  utm_medium website
*/
CREATE TABLE IF NOT EXISTS site (
  id int PRIMARY KEY,
  utm_source VARCHAR(255),
  utm_campaign VARCHAR(255),
  utm_medium VARCHAR(255),
  brand VARCHAR(255),
  intro VARCHAR(255),
  keywords VARCHAR(255),
  header TEXT,
  footer TEXT
);
INSERT INTO site (id,utm_source, utm_campaign, utm_medium, brand, intro,keywords, header, footer)
VALUES ( 1,
       '',
       'Ai Wiki',
       'website',
       'Ai wiki',
       '',
       '',
       '',
       '<div class="content has-text-centered">
         <p><strong>Aiwiki</strong> by <a href="https://github.com/DavidAlphaFox">David Gao</a></p>
        </div>'
);

CREATE TABLE IF NOT EXISTS users (
 id BIGSERIAL PRIMARY KEY,
 username VARCHAR(255) NOT NULL,
 password VARCHAR(255) NOT NULL
);
CREATE UNIQUE INDEX users_username_key on users(username);

CREATE TABLE IF NOT EXISTS topics (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(255),
  intro TEXT
);
CREATE UNIQUE INDEX topics_title_key ON topics(title);
INSERT INTO topics (title,intro)
VALUES ( '杂谈','全站点没有进行分类的文章聚集地，包含了各个方面的文章');
INSERT INTO topics (title,intro)
VALUES ( 'EMQ','介绍IoT通讯协议MQTT和使用Erlang开发的两款MQTT服务器EMQ和VerneMQ，及对这两款服务器的代码分析，调优化和二次开发');
INSERT INTO topics (title,intro)
VALUES ( 'ejabberd','介绍即时通讯协议XMPP和使用Erlang开发的即时通讯服务器ejabberd和MongooseIM，及对这两款服务器的代码分析，调优化和二次开发');
INSERT INTO topics (title,intro)
VALUES ( 'OCaml','学习OCaml以及使用OCaml开发应用时的一些经验和总结');
INSERT INTO topics (title,intro)
VALUES ( 'Lisp','学习Common Lisp，Scheme和使用Common Lisp开发应用时的一些经验和总结');
INSERT INTO topics (title,intro)
VALUES ( 'Erlang','学习Erlang，使用Erlang以及对Erlang代码分析和调优经验总结');
