CREATE TABLE student
(
        record_book numeric( 5 ) NOT NULL,
        name text NOT NULL,
        doc_ser numeric( 4 ),
        doc_num numeric( 6 ),
        who_adds_row text DEFAULT current_user, -- добавленный столбец
        PRIMARY KEY ( record_book )
);

INSERT INTO student
VALUES (10011, 'Ivan', 1001, 100111);

SELECT * FROM student;

ALTER TABLE student
    ADD COLUMN date_created timestamp DEFAULT current_timestamp;

ALTER TABLE student
    ALTER COLUMN date_created SET NOT NULL;

CREATE TABLE progress
(

)

SHOW search_path;

SET search_path TO bookings,public;