-- Ćwiczenie 1A
INSERT INTO user_sdo_geom_metadata
VALUES (
    'FIGURY',
    'KSZTALT',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', 0, 10, 0.01),
        MDSYS.SDO_DIM_ELEMENT('Y', 0, 10, 0.01)
    ),
    NULL
);

COMMIT;

-- Ćwiczenie 1B
SELECT SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(
    3000000,
    8192,
    10,
    2,
    0
) AS estimated_size_kb
FROM dual;

-- Ćwiczenie 1C
CREATE INDEX figury_idx
ON figury(ksztalt)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

-- Ćwiczenie 1D
SELECT id
FROM figury
WHERE SDO_FILTER(
    ksztalt,
    MDSYS.SDO_GEOMETRY(
        2001,
        NULL,
        MDSYS.SDO_POINT_TYPE(3,3,NULL),
        NULL,
        NULL
    )
) = 'TRUE';

-- Ćwiczenie 1E
SELECT id
FROM figury
WHERE SDO_RELATE(
    ksztalt,
    MDSYS.SDO_GEOMETRY(
        2001,
        NULL,
        MDSYS.SDO_POINT_TYPE(3,3,NULL),
        NULL,
        NULL
    ),
    'MASK=ANYINTERACT'
) = 'TRUE';

-- Ćwiczenie 2A
SELECT
    c.city_name AS miasto,
    SDO_NN_DISTANCE(1) AS odl
FROM major_cities c
WHERE SDO_NN(
    c.geom,
    (SELECT geom FROM major_cities WHERE city_name = 'Warsaw'),
    'SDO_NUM_RES=9',
    1
) = 'TRUE'
ORDER BY odl;

-- Ćwiczenie 2B
SELECT city_name
FROM major_cities
WHERE SDO_WITHIN_DISTANCE(
    geom,
    (SELECT geom FROM major_cities WHERE city_name = 'Warsaw'),
    'DISTANCE=100'
) = 'TRUE';

-- Ćwiczenie 2C
SELECT
    c.cntry_name AS kraj,
    c.city_name AS miasto
FROM major_cities c, country_boundaries b
WHERE b.cntry_name = 'Slovakia'
AND SDO_RELATE(
    c.geom,
    b.geom,
    'MASK=INSIDE'
) = 'TRUE';

-- Ćwiczenie 2D
SELECT
    b2.cntry_name AS panstwo,
    SDO_DISTANCE(b1.geom, b2.geom, 0.01) AS odl
FROM country_boundaries b1, country_boundaries b2
WHERE b1.cntry_name = 'Poland'
AND SDO_RELATE(
    b1.geom,
    b2.geom,
    'MASK=DISJOINT'
) = 'TRUE';

-- Ćwiczenie 3A
SELECT
    b2.cntry_name,
    SDO_GEOM.SDO_LENGTH(
        SDO_GEOM.SDO_INTERSECTION(b1.geom, b2.geom, 0.01),
        0.01
    ) AS odleglosc
FROM country_boundaries b1, country_boundaries b2
WHERE b1.cntry_name = 'Poland'
AND SDO_RELATE(
    b1.geom,
    b2.geom,
    'MASK=TOUCH'
) = 'TRUE';

-- Ćwiczenie 3B
SELECT cntry_name
FROM country_boundaries
ORDER BY SDO_GEOM.SDO_AREA(geom, 0.01) DESC
FETCH FIRST 1 ROW ONLY;

-- Ćwiczenie 3C
SELECT
    SDO_GEOM.SDO_AREA(
        SDO_GEOM.SDO_MBR(
            SDO_AGGR_UNION(
                MDSYS.SDOAGGRTYPE(geom, 0.01)
            )
        ),
        0.01
    ) AS sq_km
FROM major_cities
WHERE city_name IN ('Warsaw', 'Lodz');

-- Ćwiczenie 3D
SELECT
    SDO_GEOM.SDO_UNION(
        (SELECT geom FROM country_boundaries WHERE cntry_name = 'Poland'),
        (SELECT geom FROM major_cities WHERE city_name = 'Prague'),
        0.01
    ).SDO_GTYPE AS gtype
FROM dual;

-- Ćwiczenie 3E
SELECT
    c.city_name,
    c.cntry_name
FROM major_cities c, country_boundaries b
WHERE c.cntry_name = b.cntry_name
AND SDO_NN(
    c.geom,
    SDO_GEOM.SDO_CENTROID(b.geom, 0.01),
    'SDO_NUM_RES=1',
    1
) = 'TRUE';

-- Ćwiczenie 3F
SELECT
    r.name,
    SDO_GEOM.SDO_LENGTH(
        SDO_GEOM.SDO_INTERSECTION(r.geom, b.geom, 0.01),
        0.01
    ) AS dlugosc
FROM rivers r, country_boundaries b
WHERE b.cntry_name = 'Poland'
AND SDO_RELATE(
    r.geom,
    b.geom,
    'MASK=ANYINTERACT'
) = 'TRUE';
