CREATE TABLE course_records%SUFFIX% (
  id serial NOT NULL,
  aggregate_id uuid NOT NULL,
  title character varying,
  description character varying,
  CONSTRAINT course_records_pkey%SUFFIX% PRIMARY KEY (id)
);

CREATE UNIQUE INDEX unique_aggregate_id%SUFFIX% ON course_records%SUFFIX% USING btree (aggregate_id);
