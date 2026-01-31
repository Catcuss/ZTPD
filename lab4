-- Zadanie 1A
CREATE TABLE figury (
    id NUMBER(1) PRIMARY KEY,
    ksztalt MDSYS.SDO_GEOMETRY
);

-- Zadanie 1B
INSERT INTO figury VALUES (
    1,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,4),
        MDSYS.SDO_ORDINATE_ARRAY(3,6, 6,6, 6,9)
    )
);

INSERT INTO figury VALUES (
    2,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,1),
        MDSYS.SDO_ORDINATE_ARRAY(1,1, 5,1, 5,5, 1,5, 1,1)
    )
);

INSERT INTO figury VALUES (
    3,
    MDSYS.SDO_GEOMETRY(
        2002,
        NULL,
        NULL,
        MDSYS.SDO_ELEM_INFO_ARRAY(1,2,1),
        MDSYS.SDO_ORDINATE_ARRAY(3,3, 7,4, 8,3)
    )
);

-- Zadanie 1C
INSERT INTO figury VALUES (
    4,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,1),
        MDSYS.SDO_ORDINATE_ARRAY(1,1, 4,1, 4,4, 1,4)
    )
);

-- Zadanie 1D
SELECT
    id,
    SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.005) AS val
FROM figury;

-- Zadanie 1E
DELETE FROM figury
WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.005) <> 'TRUE';

-- Zadanie 1F
COMMIT;
