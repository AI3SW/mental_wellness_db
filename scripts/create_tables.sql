-- set search path
SET search_path TO public;

-- drop tables
DROP TABLE IF EXISTS "result";

DROP TABLE IF EXISTS "option";

DROP TABLE IF EXISTS "question";

DROP TABLE IF EXISTS "job";

DROP TABLE IF EXISTS "session";

DROP TABLE IF EXISTS "output_img";

DROP TABLE IF EXISTS "input_img";

DROP TABLE IF EXISTS "style_img";

DROP TABLE IF EXISTS "theme";

DROP TABLE IF EXISTS "model";

DROP TABLE IF EXISTS "user";

CREATE TABLE "user" (
    id varchar PRIMARY KEY
);

CREATE TABLE "model" (
    id serial PRIMARY KEY,
    name varchar(15)
);

CREATE TABLE "theme" (
    id serial PRIMARY KEY,
    name varchar(15)
);

CREATE TABLE "style_img" (
    id serial PRIMARY KEY,
    model_id int,
    theme_id int,
    file_path text NOT NULL,
    is_ref boolean NOT NULL,
    ref_class varchar(10),
    FOREIGN KEY (model_id) REFERENCES "model" (id) ON UPDATE CASCADE,
    FOREIGN KEY (theme_id) REFERENCES "theme" (id) ON UPDATE CASCADE
);

CREATE TABLE "input_img" (
    id serial PRIMARY KEY,
    file_path text NOT NULL
);

CREATE TABLE "output_img" (
    id serial PRIMARY KEY,
    file_path text NOT NULL
);

CREATE TABLE "session" (
    id varchar PRIMARY KEY,
    start_time timestamp with time zone DEFAULT NOW(),
    end_time timestamp with time zone,
    user_id varchar,
    FOREIGN KEY (user_id) REFERENCES "user" (id) ON UPDATE CASCADE
);

CREATE INDEX ix_session_start_time ON "session" USING btree (start_time);

CREATE INDEX ix_session_end_time ON "session" USING btree (end_time);

CREATE TABLE "job" (
    id serial PRIMARY KEY,
    session_id varchar,
    status varchar(10),
    style_img_id int,
    input_img_id int,
    output_img_id int,
    ref_class varchar(10),
    FOREIGN KEY (session_id) REFERENCES "session" (id) ON UPDATE CASCADE,
    FOREIGN KEY (style_img_id) REFERENCES "style_img" (id) ON UPDATE CASCADE,
    FOREIGN KEY (input_img_id) REFERENCES "input_img" (id) ON UPDATE CASCADE,
    FOREIGN KEY (output_img_id) REFERENCES "output_img" (id) ON UPDATE CASCADE
);

CREATE INDEX ix_job_session_id ON "job" USING btree (session_id);

CREATE TABLE "question" (
    id serial PRIMARY KEY,
    text text
);

CREATE TABLE "option" (
    id serial PRIMARY KEY,
    question_id int,
    text text,
    weight real,
    FOREIGN KEY (question_id) REFERENCES "question" (id) ON UPDATE CASCADE
);

CREATE TABLE "result" (
    id serial PRIMARY KEY,
    session_id varchar,
    option_id int,
    sequence_no int,
    FOREIGN KEY (session_id) REFERENCES "session" (id) ON UPDATE CASCADE,
    FOREIGN KEY (option_id) REFERENCES "option" (id) ON UPDATE CASCADE
);

CREATE INDEX ix_result_session_id ON "result" USING btree (session_id);

