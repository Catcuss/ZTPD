-- Zadanie 1
CREATE TABLE cytaty AS
SELECT * FROM ztpd.cytaty;

-- Zadanie 2
SELECT autor, tekst
FROM cytaty
WHERE LOWER(tekst) LIKE '%optymista%'
AND LOWER(tekst) LIKE '%pesymista%';

-- Zadanie 3
CREATE INDEX cytaty_ctx
ON cytaty(tekst)
INDEXTYPE IS CTXSYS.CONTEXT;

-- Zadanie 4
SELECT autor, tekst
FROM cytaty
WHERE CONTAINS(tekst, 'optymista AND pesymista', 1) > 0;

-- Zadanie 5
SELECT autor, tekst
FROM cytaty
WHERE CONTAINS(tekst, 'pesymista NOT optymista', 1) > 0;

-- Zadanie 6
SELECT autor, tekst
FROM cytaty
WHERE CONTAINS(tekst, 'NEAR((optymista, pesymista), 3)', 1) > 0;

-- Zadanie 7
SELECT autor, tekst
FROM cytaty
WHERE CONTAINS(tekst, 'NEAR((optymista, pesymista), 10)', 1) > 0;

-- Zadanie 8
SELECT autor, tekst
FROM cytaty
WHERE CONTAINS(tekst, 'życi%', 1) > 0;

-- Zadanie 9
SELECT autor, tekst, SCORE(1) AS dopasowanie
FROM cytaty
WHERE CONTAINS(tekst, 'życi%', 1) > 0;

-- Zadanie 10
SELECT autor, tekst, SCORE(1) AS dopasowanie
FROM cytaty
WHERE CONTAINS(tekst, 'życi%', 1) > 0
AND SCORE(1) = (
    SELECT MAX(SCORE(1))
    FROM cytaty
    WHERE CONTAINS(tekst, 'życi%', 1) > 0
);

-- Zadanie 11
SELECT autor, tekst
FROM cytaty
WHERE CONTAINS(tekst, 'FUZZY(probelm)', 1) > 0;

-- Zadanie 12
INSERT INTO cytaty (autor, tekst)
VALUES (
    'Bertrand Russell',
    'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.'
);
COMMIT;

-- Zadanie 13
SELECT autor, tekst
FROM cytaty
WHERE CONTAINS(tekst, 'głupcy', 1) > 0;
Indeks się nie zaktualizował automatycznie
  
-- Zadanie 14
SELECT *
FROM dr$cytaty_ctx$i;

SELECT * 
FROM dr$cytaty_idx$i 
WHERE token_text = 'GŁUPCY'
   
-- Zadanie 15
DROP INDEX cytaty_ctx;

CREATE INDEX cytaty_ctx
ON cytaty(tekst)
INDEXTYPE IS CTXSYS.CONTEXT;

-- Zadanie 16
SELECT *
FROM dr$cytaty_ctx$i;

SELECT autor, tekst
FROM cytaty
WHERE CONTAINS(tekst, 'głupcy', 1) > 0;

-- Zadanie 17
DROP INDEX cytaty_ctx;
DROP TABLE cytaty;

-- Zadanie 2.1
CREATE TABLE quotes AS
SELECT * FROM ztpd.quotes;

-- Zadanie 2.2
CREATE INDEX quotes_ctx
ON quotes(text)
INDEXTYPE IS CTXSYS.CONTEXT;

-- Zadanie 2.3
SELECT text FROM quotes WHERE CONTAINS(text, 'work', 1) > 0;
SELECT text FROM quotes WHERE CONTAINS(text, '$work', 1) > 0;
SELECT text FROM quotes WHERE CONTAINS(text, 'working', 1) > 0;
SELECT text FROM quotes WHERE CONTAINS(text, '$working', 1) > 0;

-- Zadanie 2.4
SELECT text FROM quotes WHERE CONTAINS(text, 'it', 1) > 0;
Słow It nie jest uwzględnione w indeksowaniu
  
-- Zadanie 2.5
SELECT * FROM ctx_stoplists;
-- Do tej pory system uzywal DEFAULT_STOPLIST

-- Zadanie 2.6
SELECT * FROM ctx_stopwords WHERE spw_stoplist = 'DEFAULT_STOPLIST';

-- Zadanie 2.7
DROP INDEX quotes_ctx;

CREATE INDEX quotes_ctx
ON quotes(text)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('STOPLIST CTXSYS.EMPTY_STOPLIST');

-- Zadanie 2.8
SELECT text FROM quotes WHERE CONTAINS(text, 'it', 1) > 0;

-- Zadanie 2.9
SELECT text FROM quotes WHERE CONTAINS(text, 'fool AND humans', 1) > 0;

-- Zadanie 2.10
SELECT text FROM quotes WHERE CONTAINS(text, 'fool AND computer', 1) > 0;

-- Zadanie 2.11
SELECT * FROM QUOTES WHERE CONTAINS(TEXT, '(fool AND humans) WITHIN SENTENCE', 1) > 0;
--Wyświetla się błąd, o braku istnienia sekcji sentence.
  
-- Zadanie 2.12
DROP INDEX idx_quotes_text;

-- Zadanie 2.13
BEGIN
CTX_DDL.CREATE_SECTION_GROUP('sent_group', 'NULL_SECTION_GROUP');
CTX_DDL.ADD_SPECIAL_SECTION('sent_group', 'SENTENCE');
CTX_DDL.ADD_SPECIAL_SECTION('sent_group', 'PARAGRAPH');
END;

-- Zadanie 2.14
CREATE INDEX quotes_ctx
ON quotes(text)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('SECTION GROUP sent_group');

-- Zadanie 2.15
SELECT text FROM quotes WHERE CONTAINS(text, 'SENTENCE(fool AND humans)', 1) > 0;
SELECT text FROM quotes WHERE CONTAINS(text, 'SENTENCE(fool AND computer)', 1) > 0;

-- Zadanie 2.16
SELECT text FROM quotes WHERE CONTAINS(text, 'humans', 1) > 0;

-- Zadanie 2.17
DROP INDEX quotes_ctx;

BEGIN
CTX_DDL.CREATE_PREFERENCE('my_lexer', 'BASIC_LEXER');
CTX_DDL.SET_ATTRIBUTE('my_lexer', 'PRINTJOINS', '-');
END;
/

CREATE INDEX quotes_ctx
ON quotes(text)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('LEXER my_lexer');

-- Zadanie 2.18
SELECT text FROM quotes WHERE CONTAINS(text, 'humans', 1) > 0;

-- Zadanie 2.19
SELECT text FROM quotes WHERE CONTAINS(text, 'non\-humans', 1) > 0;

-- Zadanie 2.20
DROP INDEX quotes_ctx;
DROP TABLE quotes;
BEGIN
CTX_DDL.DROP_PREFERENCE('my_lexer');
END;
/
