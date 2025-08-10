CREATE TABLE user_lesson_progress_records%SUFFIX% (
  id serial NOT NULL,
  aggregate_id uuid NOT NULL,
  user_id uuid NOT NULL,
  lesson_id uuid NOT NULL,
  course_id uuid NOT NULL,
  status character varying NOT NULL,
  CONSTRAINT user_lesson_progress_records_pkey%SUFFIX% PRIMARY KEY (id)
);

CREATE UNIQUE INDEX index_user_lesson_progress_unique%SUFFIX%
  ON user_lesson_progress_records%SUFFIX% USING btree (user_id, lesson_id);

CREATE INDEX index_user_lesson_progress_on_course%SUFFIX%
  ON user_lesson_progress_records%SUFFIX% USING btree (course_id);
