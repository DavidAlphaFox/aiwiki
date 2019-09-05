CREATE TABLE IF NOT EXISTS pages (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(255),
  intro TEXT,
  content TEXT,
  published BOOLEAN DEFAULT false,
  published_date TIMESTAMP WITHOUT TIME ZONE DEFAULT (now() AT TIME ZONE 'UTC')
);
CREATE UNIQUE INDEX pages_title_key ON pages(title);

CREATE TABLE IF NOT EXISTS tags (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(255),
  intro TEXT,
  enabled BOOLEAN DEFAULT true
);
CREATE UNIQUE INDEX tags_title_key ON tags(title);

CREATE TABLE IF NOT EXISTS page_tags(
  id BIGSERIAL PRIMARY KEY,
  page_id BIGINT,
  tag_id BIGINT
);

CREATE UNIQUE INDEX page_tag_key on page_tags(page_id,tag_id);
