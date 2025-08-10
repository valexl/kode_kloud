CREATE TABLE user_course_progress_records%SUFFIX% (
  id serial NOT NULL,
  aggregate_id uuid NOT NULL,
  user_id uuid NOT NULL,
  course_id uuid NOT NULL,
  progress integer NOT NULL,
  CONSTRAINT user_course_progress_records_pkey%SUFFIX% PRIMARY KEY (id)
);

CREATE UNIQUE INDEX index_user_course_progress_unique%SUFFIX%
  ON user_course_progress_records%SUFFIX% USING btree (user_id, course_id);
