​​​​​-- Zadanie 1
create table movies as select * from ztpd.movies;
-- Zadanie 2
describe movies;
-- Zadanie 3
select id, title from movies where cover is null;
-- Zadanie 4
select id, title, dbms_lob.getlength(cover) as filesize from movies where cover is not null;
-- Zadanie 5
select id, title, dbms_lob.getlength(cover) as filesize from movies where cover is null;
Będzie mieć wartości NULL;
-- Zadanie 6
select DIRECTORY_NAME, DIRECTORY_PATH from ALL_DIRECTORIES where DIRECTORY_NAME = 'TPD_DIR'
-- Zadanie 7
update movies set cover = EMPTY_BLOB(), mime_type = 'image/jpeg' where id = 66;
-- Zadanie 8
select id, title, dbms_lob.getlength(cover) as filesize from movies where id in (65, 66);
-- Zadanie 9
DECLARE
lobd blob;
fils BFILE := BFILENAME('TPD_DIR','escape.jpg');
BEGIN
SELECT cover INTO lobd
FROM movies
where id=66
FOR UPDATE;
DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
DBMS_LOB.FILECLOSE(fils);
COMMIT;
END;
/
-- Zadanie 10
CREATE TABLE TEMP_COVERS(
    movie_id number(12),
    image bfile,
    mime_type varchar(50)
);
-- Zadanie 11
insert into temp_covers values (65, BFILENAME('TPD_DIR','eagles.jpg'), 'image/jpeg');
commit;
-- Zadanie 12
select movie_id, dbms_lob.getlength(image) as filesize from temp_covers;
-- Zadanie 13
DECLARE
    tmp BLOB;
    fils BFILE;
    v_mimetype VARCHAR2(50);
BEGIN
    SELECT image, mime_type INTO fils, v_mimetype FROM temp_covers WHERE movie_id = 65;
    DBMS_LOB.createtemporary(tmp, TRUE);
    DBMS_LOB.FILEOPEN(fils, DBMS_LOB.FILE_READONLY);
    DBMS_LOB.LOADFROMFILE(tmp, fils, DBMS_LOB.GETLENGTH(fils));
    DBMS_LOB.FILECLOSE(fils);
    UPDATE movies
    SET cover = tmp,
        mime_type = v_mimetype
    WHERE id = 65;
    DBMS_LOB.FREETEMPORARY(tmp);
    COMMIT;
END;
-- Zadanie 14
select id, title, dbms_lob.getlength(cover) as filesize from movies where id in (65, 66);
-- Zadanie 15
drop table movies;
