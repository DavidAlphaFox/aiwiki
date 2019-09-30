CREATE TABLE IF NOT EXISTS pages (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  intro TEXT,
  content TEXT,
  published BOOLEAN DEFAULT false,
  published_at TIMESTAMP WITHOUT TIME ZONE DEFAULT (now() AT TIME ZONE 'UTC')
);
CREATE UNIQUE INDEX pages_title_key ON pages(title);

CREATE TABLE IF NOT EXISTS tags (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(255),
  intro TEXT,
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
       'ttalk.im',
       'Tech Talk',
       'website',
       'Tech Talk',
       '',
       '这是一个在全栈工程师的博客,Teach Talk,ttalk,ttalk.im',
       '',
       '<div class="content has-text-centered">
         <p><strong>Tech Talk</strong> by <a href="https://github.com/DavidAlphaFox">David Gao</a></p>
        </div>'
);

CREATE TABLE IF NOT EXISTS users (
 id BIGSERIAL PRIMARY KEY,
 username VARCHAR(255) NOT NULL,
 password VARCHAR(255) NOT NULL
);
CREATE UNIQUE INDEX users_username_key on users(username);
