SET SERVEROUTPUT ON;

-- Zadanie 1
CREATE OR REPLACE TYPE SAMOCHOD AS OBJECT (
    MARKA VARCHAR2(20),
    MODEL VARCHAR2(20),
    KILOMETRY NUMBER,
    DATA_PRODUKCJI DATE,
    CENA NUMBER(10,2)
);
/

CREATE TABLE SAMOCHODY OF SAMOCHOD;

INSERT INTO SAMOCHODY VALUES (SAMOCHOD('FIAT', 'BRAVA', 60000, TO_DATE('30-11-1999', 'DD-MM-YYYY'), 25000));
INSERT INTO SAMOCHODY VALUES (SAMOCHOD('FORD', 'MONDEO', 80000, TO_DATE('10-05-1997', 'DD-MM-YYYY'), 45000));
INSERT INTO SAMOCHODY VALUES (SAMOCHOD('MAZDA', '323', 12000, TO_DATE('22-09-2000', 'DD-MM-YYYY'), 52000));

SELECT * FROM SAMOCHODY;

-- Zadanie 2
ALTER TYPE SAMOCHOD ADD MEMBER FUNCTION wartosc RETURN NUMBER CASCADE;
/

CREATE OR REPLACE TYPE BODY SAMOCHOD AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        wiek NUMBER;
    BEGIN
        wiek := EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM DATA_PRODUKCJI);
        IF wiek < 0 THEN wiek := 0; END IF;
        RETURN CENA * POWER(0.9, wiek);
    END;
END;
/

SELECT s.marka, s.cena, s.wartosc() FROM SAMOCHODY s;

-- Zadanie 3
ALTER TYPE SAMOCHOD ADD MAP MEMBER FUNCTION odwzoruj RETURN NUMBER CASCADE;
/

CREATE OR REPLACE TYPE BODY SAMOCHOD AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        wiek NUMBER;
    BEGIN
        wiek := EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM DATA_PRODUKCJI);
        IF wiek < 0 THEN wiek := 0; END IF;
        RETURN CENA * POWER(0.9, wiek);
    END;

    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
    BEGIN
        RETURN (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM DATA_PRODUKCJI)) + (KILOMETRY / 10000);
    END;
END;
/

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);

-- Zadanie 4
CREATE TABLE WLASCICIELE (
    IMIE VARCHAR2(100),
    NAZWISKO VARCHAR2(100),
    AUTO SAMOCHOD
);

INSERT INTO WLASCICIELE VALUES ('JAN', 'KOWALSKI', SAMOCHOD('FIAT', 'SEICENTO', 30000, TO_DATE('02-12-2010', 'DD-MM-YYYY'), 19500));
INSERT INTO WLASCICIELE VALUES ('ADAM', 'NOWAK', SAMOCHOD('OPEL', 'ASTRA', 34000, TO_DATE('01-06-2009', 'DD-MM-YYYY'), 33700));

SELECT * FROM WLASCICIELE;

-- Zadanie 5
DROP TABLE WLASCICIELE;

-- Zadanie 6
CREATE OR REPLACE TYPE WLASCICIEL AS OBJECT (
    IMIE VARCHAR2(100),
    NAZWISKO VARCHAR2(100)
);
/

CREATE TABLE WLASCICIELE OF WLASCICIEL;

INSERT INTO WLASCICIELE VALUES (WLASCICIEL('JAN', 'KOWALSKI'));
INSERT INTO WLASCICIELE VALUES (WLASCICIEL('ADAM', 'NOWAK'));
INSERT INTO WLASCICIELE VALUES (WLASCICIEL('PIOTR', 'WISNIEWSKI'));

SELECT * FROM WLASCICIELE;

-- Zadanie 7
ALTER TYPE SAMOCHOD ADD ATTRIBUTE wlasciciel_ref REF WLASCICIEL CASCADE;
/

-- Zadanie 8
DELETE FROM SAMOCHODY;

-- Zadanie 9
ALTER TABLE SAMOCHODY ADD (SCOPE FOR (wlasciciel_ref) IS WLASCICIELE);

-- Zadanie 10
INSERT INTO SAMOCHODY VALUES (SAMOCHOD('FIAT', 'PUNTO', 10000, TO_DATE('01-01-2020', 'DD-MM-YYYY'), 30000, (SELECT REF(w) FROM WLASCICIELE w WHERE w.NAZWISKO = 'KOWALSKI')));
INSERT INTO SAMOCHODY VALUES (SAMOCHOD('FORD', 'FOCUS', 20000, TO_DATE('01-01-2019', 'DD-MM-YYYY'), 40000, (SELECT REF(w) FROM WLASCICIELE w WHERE w.NAZWISKO = 'NOWAK')));

SELECT s.MARKA, s.MODEL, s.wlasciciel_ref.NAZWISKO FROM SAMOCHODY s;

-- Zadanie 11
DECLARE 
    TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20); 
    moje_przedmioty t_przedmioty := t_przedmioty(''); 
BEGIN 
    moje_przedmioty(1) := 'MATEMATYKA'; 
    moje_przedmioty.EXTEND(9); 
    FOR i IN 2..10 LOOP 
        moje_przedmioty(i) := 'PRZEDMIOT_' || i; 
    END LOOP; 
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP 
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i)); 
    END LOOP; 
    moje_przedmioty.TRIM(2); 
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP 
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i)); 
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT()); 
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT()); 
    moje_przedmioty.EXTEND(); 
    moje_przedmioty(9) := 'WF'; 
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT()); 
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT()); 
    moje_przedmioty.DELETE(); 
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT()); 
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT()); 
END;
/

-- Zadanie 12
DECLARE
    TYPE t_ksiazki IS VARRAY(5) OF VARCHAR2(100);
    biblioteka t_ksiazki := t_ksiazki();
BEGIN
    biblioteka.EXTEND(2);
    biblioteka(1) := 'Wiedzmin';
    biblioteka(2) := 'Hobbit';
    
    biblioteka.EXTEND;
    biblioteka(3) := 'Diuna';
    
    DBMS_OUTPUT.PUT_LINE('Ksiazki w bibliotece:');
    FOR i IN biblioteka.FIRST..biblioteka.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(biblioteka(i));
    END LOOP;
    
    biblioteka.TRIM(1); 
    
    DBMS_OUTPUT.PUT_LINE('Po usunieciu ostatniej:');
    FOR i IN biblioteka.FIRST..biblioteka.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(biblioteka(i));
    END LOOP;
END;
/

-- Zadanie 13
DECLARE 
   TYPE t_wykladowcy IS TABLE OF VARCHAR2(20); 
   moi_wykladowcy t_wykladowcy := t_wykladowcy(); 
BEGIN 
   moi_wykladowcy.EXTEND(2); 
   moi_wykladowcy(1) := 'MORZY'; 
   moi_wykladowcy(2) := 'WOJCIECHOWSKI'; 
   moi_wykladowcy.EXTEND(8); 
   FOR i IN 3..10 LOOP 
     moi_wykladowcy(i) := 'WYKLADOWCA_' || i; 
   END LOOP; 
   FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP 
     DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i)); 
   END LOOP; 
   moi_wykladowcy.TRIM(2); 
   FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP 
     DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i)); 
   END LOOP; 
   moi_wykladowcy.DELETE(5,7); 
   DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT()); 
   DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT()); 
   FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP 
     IF moi_wykladowcy.EXISTS(i) THEN 
       DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i)); 
     END IF; 
   END LOOP; 
   moi_wykladowcy(5) := 'ZAKRZEWICZ'; 
   moi_wykladowcy(6) := 'KROLIKOWSKI'; 
   moi_wykladowcy(7) := 'KOSZLAJDA'; 
   FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP 
     IF moi_wykladowcy.EXISTS(i) THEN 
       DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i)); 
     END IF; 
   END LOOP; 
   DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT()); 
   DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT()); 
END; 
/

-- Zadanie 14
DECLARE
    TYPE t_miesiace IS TABLE OF VARCHAR2(20);
    rok t_miesiace := t_miesiace();
BEGIN
    rok.EXTEND(12);
    rok(1) := 'Styczen'; rok(2) := 'Luty'; rok(3) := 'Marzec';
    rok(4) := 'Kwiecien'; rok(5) := 'Maj'; rok(6) := 'Czerwiec';
    rok(7) := 'Lipiec'; rok(8) := 'Sierpien'; rok(9) := 'Wrzesien';
    rok(10) := 'Pazdziernik'; rok(11) := 'Listopad'; rok(12) := 'Grudzien';
    
    rok.DELETE(7, 8); 
    
    FOR i IN rok.FIRST..rok.LAST LOOP
        IF rok.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(rok(i));
        END IF;
    END LOOP;
END;
/

-- Zadanie 15
CREATE OR REPLACE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE OR REPLACE TYPE stypendium AS OBJECT (
    nazwa VARCHAR2(50),
    kraj  VARCHAR2(30),
    jezyki jezyki_obce
);
/
CREATE TABLE stypendia OF stypendium;

INSERT INTO stypendia VALUES ('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES ('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));

SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;

UPDATE STYPENDIA SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI') WHERE nazwa = 'ERASMUS';

CREATE OR REPLACE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE OR REPLACE TYPE semestr AS OBJECT (
    numer NUMBER,
    egzaminy lista_egzaminow
);
/
CREATE TABLE semestry OF semestr NESTED TABLE egzaminy STORE AS tab_egzaminy;

INSERT INTO semestry VALUES (semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES (semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));

SELECT s.numer, e.* FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.* FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );

INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) VALUES ('METODY NUMERYCZNE');

UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e SET e.column_value = 'SYSTEMY ROZPROSZONE' WHERE e.column_value = 'SYSTEMY OPERACYJNE';

DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e WHERE e.column_value = 'BAZY DANYCH';

-- Zadanie 16
CREATE OR REPLACE TYPE t_produkty AS TABLE OF VARCHAR2(50);
/
CREATE TABLE ZAKUPY (
    id_zakupu NUMBER,
    koszyk t_produkty
) NESTED TABLE koszyk STORE AS tab_koszyk;

INSERT INTO ZAKUPY VALUES (1, t_produkty('MLEKO', 'CHLEB', 'MASLO'));
INSERT INTO ZAKUPY VALUES (2, t_produkty('SOK', 'WODA', 'CHLEB'));
INSERT INTO ZAKUPY VALUES (3, t_produkty('JAJKA', 'MIESO'));

SELECT z.id_zakupu, k.* FROM ZAKUPY z, TABLE(z.koszyk) k;

DELETE FROM ZAKUPY z 
WHERE EXISTS (SELECT 1 FROM TABLE(z.koszyk) k WHERE k.column_value = 'MLEKO');

SELECT z.id_zakupu, k.* FROM ZAKUPY z, TABLE(z.koszyk) k;

-- Zadanie 17
CREATE OR REPLACE TYPE instrument AS OBJECT (
    nazwa VARCHAR2(20),
    dzwiek VARCHAR2(20),
    MEMBER FUNCTION graj RETURN VARCHAR2
) NOT FINAL;
/
CREATE OR REPLACE TYPE BODY instrument AS
    MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN dzwiek;
    END;
END;
/
CREATE OR REPLACE TYPE instrument_dety UNDER instrument (
    material VARCHAR2(20),
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
    MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2
);
/
CREATE OR REPLACE TYPE BODY instrument_dety AS
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN 'dmucham: '||dzwiek;
    END;
    MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN glosnosc||':'||dzwiek;
    END;
END;
/
CREATE OR REPLACE TYPE instrument_klawiszowy UNDER instrument (
    producent VARCHAR2(20),
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2
);
/
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN 'stukam w klawisze: '||dzwiek;
    END;
END;
/
DECLARE
    tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
    trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
    fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
    dbms_output.put_line(tamburyn.graj);
    dbms_output.put_line(trabka.graj);
    dbms_output.put_line(trabka.graj('glosno'));
    dbms_output.put_line(fortepian.graj);
END;
/

-- Zadanie 18
CREATE OR REPLACE TYPE istota AS OBJECT (
    nazwa VARCHAR2(20),
    NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR
) NOT INSTANTIABLE NOT FINAL;
/
CREATE OR REPLACE TYPE lew UNDER istota (
    liczba_nog NUMBER,
    OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR
);
/
CREATE OR REPLACE TYPE BODY lew AS
    OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
    BEGIN
        RETURN 'upolowana ofiara: '||ofiara;
    END;
END;
/
DECLARE
    KrolLew lew := lew('LEW',4);
    -- InnaIstota istota := istota('JAKIES ZWIERZE'); -- Odkomentowanie spowoduje blad (istota jest abstrakcyjna)
BEGIN
    DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;
/

-- Zadanie 19
DECLARE
    tamburyn instrument;
    cymbalki instrument;
    trabka instrument_dety;
    saksofon instrument_dety;
BEGIN
    tamburyn := instrument('tamburyn','brzdek-brzdek');
    cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
    trabka   := instrument_dety('trabka','tra-ta-ta','metalowa');
    -- saksofon := instrument('saksofon','tra-taaaa');
    -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;
/

-- Zadanie 20
CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa') );
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;
