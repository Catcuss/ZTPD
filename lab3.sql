SET SERVEROUTPUT ON;

-- Zadanie 1
CREATE TABLE dokumenty (
    id       NUMBER(12) PRIMARY KEY,
    dokument CLOB
);

-- Zadanie 2
DECLARE
    v_clob CLOB;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_clob, TRUE);
    FOR i IN 1..10000 LOOP
        DBMS_LOB.WRITEAPPEND(v_clob, LENGTH('Oto tekst. '), 'Oto tekst. ');
    END LOOP;
    INSERT INTO dokumenty (id, dokument) VALUES (1, v_clob);
    DBMS_LOB.FREETEMPORARY(v_clob);
END;
/

-- Zadanie 3a
SELECT * FROM dokumenty;

-- Zadanie 3b
SELECT id, UPPER(dokument) FROM dokumenty;

-- Zadanie 3c
SELECT id, LENGTH(dokument) FROM dokumenty;

-- Zadanie 3d
SELECT id, DBMS_LOB.GETLENGTH(dokument) FROM dokumenty;

-- Zadanie 3e
SELECT id, SUBSTR(dokument, 5, 1000) FROM dokumenty;

-- Zadanie 3f
SELECT id, DBMS_LOB.SUBSTR(dokument, 1000, 5) FROM dokumenty;

-- Zadanie 4
INSERT INTO dokumenty (id, dokument) VALUES (2, EMPTY_CLOB());

-- Zadanie 5
INSERT INTO dokumenty (id, dokument) VALUES (3, NULL);
COMMIT;

-- Zadanie 6
SELECT
    id,
    LENGTH(dokument) AS length_fun,
    DBMS_LOB.GETLENGTH(dokument) AS dbms_lob_length
FROM dokumenty;

-- Zadanie 7
DECLARE
    v_bfile      BFILE;
    v_clob       CLOB;
    v_dest_off   INTEGER := 1;
    v_src_off    INTEGER := 1;
    v_lang_ctx   INTEGER := 0;
    v_warning    INTEGER;
BEGIN
    v_bfile := BFILENAME('TPD_DIR', 'dokument.txt');
    SELECT dokument INTO v_clob FROM dokumenty WHERE id = 2 FOR UPDATE;
    DBMS_LOB.OPEN(v_bfile, DBMS_LOB.LOB_READONLY);
    DBMS_LOB.LOADCLOBFROMFILE(
        v_clob,
        v_bfile,
        DBMS_LOB.GETLENGTH(v_bfile),
        v_dest_off,
        v_src_off,
        0,
        v_lang_ctx,
        v_warning
    );
    DBMS_LOB.CLOSE(v_bfile);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status kopiowania: ' || v_warning);
END;
/

-- Zadanie 8
UPDATE dokumenty
SET dokument = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt'))
WHERE id = 3;
COMMIT;

-- Zadanie 9
SELECT * FROM dokumenty;

-- Zadanie 10
SELECT id, DBMS_LOB.GETLENGTH(dokument) FROM dokumenty;

-- Zadanie 11
DROP TABLE dokumenty;

-- Zadanie 12
CREATE OR REPLACE PROCEDURE clob_censor (
    p_clob IN OUT CLOB,
    p_text IN VARCHAR2
) IS
    v_pos INTEGER := 1;
    v_len INTEGER := LENGTH(p_text);
    v_dots VARCHAR2(32767);
BEGIN
    v_dots := RPAD('.', v_len, '.');
    LOOP
        v_pos := DBMS_LOB.INSTR(p_clob, p_text, v_pos);
        EXIT WHEN v_pos = 0;
        DBMS_LOB.WRITE(p_clob, v_len, v_pos, v_dots);
        v_pos := v_pos + v_len;
    END LOOP;
END;
/

-- Zadanie 13
CREATE TABLE biographies AS
SELECT * FROM ztpd.biographies;

DECLARE
    v_clob CLOB;
BEGIN
    SELECT biography INTO v_clob
    FROM biographies
    WHERE person = 'Jára Cimrman'
    FOR UPDATE;

    clob_censor(v_clob, 'Cimrman');

    UPDATE biographies
    SET biography = v_clob
    WHERE person = 'Jára Cimrman';

    COMMIT;
END;
/

-- Zadanie 14
DROP TABLE biographies;
