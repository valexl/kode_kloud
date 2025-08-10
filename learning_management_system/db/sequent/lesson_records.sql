CREATE TABLE lesson_records%SUFFIX% (
  id serial NOT NULL,
  aggregate_id uuid NOT NULL,
  course_id uuid NOT NULL,
  title character varying,
  description character varying,
  CONSTRAINT lesson_records_pkey%SUFFIX% PRIMARY KEY (id)
);

CREATE UNIQUE INDEX unique_lesson_aggregate_id%SUFFIX%
  ON lesson_records%SUFFIX% USING btree (aggregate_id);

CREATE INDEX index_lesson_records_on_course_id%SUFFIX%
  ON lesson_records%SUFFIX% USING btree (course_id);
