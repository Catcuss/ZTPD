-- Ćwiczenie 1A
SELECT
    LPAD('-', 2*(LEVEL-1), '|-') ||
    t.owner || '.' || t.type_name ||
    ' (FINAL:' || t.final ||
    ', INSTANTIABLE:' || t.instantiable ||
    ', ATTRIBUTES:' || t.attributes ||
    ', METHODS:' || t.methods || ')'
FROM all_types t
START WITH t.type_name = 'ST_GEOMETRY'
CONNECT BY PRIOR t.type_name = t.supertype_name
AND PRIOR t.owner = t.owner;

-- Ćwiczenie 1B
SELECT DISTINCT m.method_name
FROM all_type_methods m
WHERE m.type_name = 'ST_POLYGON'
AND m.owner = 'MDSYS'
ORDER BY 1;

-- Ćwiczenie 1C
CREATE TABLE myst_major_cities (
    fips_cntry VARCHAR2(2),
    city_name  VARCHAR2(40),
    stgeom     MDSYS.ST_POINT
);

-- Ćwiczenie 1D
INSERT INTO myst_major_cities
SELECT
    fips_cntry,
    city_name,
    MDSYS.ST_POINT(geom)
FROM major_cities;

COMMIT;

-- Ćwiczenie 2A
INSERT INTO myst_major_cities
VALUES (
    'PL',
    'Szczyrk',
    MDSYS.ST_POINT(19.036107, 49.718655, 8307)
);

COMMIT;

-- Ćwiczenie 3A
CREATE TABLE myst_country_boundaries (
    fips_cntry VARCHAR2(2),
    cntry_name VARCHAR2(40),
    stgeom     MDSYS.ST_MULTIPOLYGON
);

-- Ćwiczenie 3B
INSERT INTO myst_country_boundaries
SELECT
    fips_cntry,
    cntry_name,
    MDSYS.ST_MULTIPOLYGON(geom)
FROM country_boundaries;

COMMIT;

-- Ćwiczenie 3C
SELECT
    stgeom.ST_GEOMETRYTYPE() AS typ_obiektu,
    COUNT(*) AS ile
FROM myst_country_boundaries
GROUP BY stgeom.ST_GEOMETRYTYPE();

-- Ćwiczenie 3D
SELECT
    stgeom.ST_ISSIMPLE()
FROM myst_country_boundaries;

-- Ćwiczenie 4A
SELECT
    b.cntry_name,
    COUNT(*) 
FROM myst_country_boundaries b
JOIN myst_major_cities c
ON c.stgeom.ST_WITHIN(b.stgeom) = 1
GROUP BY b.cntry_name;

-- Ćwiczenie 4B
SELECT
    a.cntry_name AS a_name,
    b.cntry_name AS b_name
FROM myst_country_boundaries a
JOIN myst_country_boundaries b
ON a.stgeom.ST_TOUCHES(b.stgeom) = 1
WHERE b.cntry_name = 'Czech Republic';

-- Ćwiczenie 4C
SELECT
    b.cntry_name,
    r.name
FROM rivers r
JOIN myst_country_boundaries b
ON MDSYS.ST_LINESTRING(r.geom).ST_INTERSECTS(b.stgeom) = 1
WHERE b.cntry_name = 'Czech Republic';

-- Ćwiczenie 4D
SELECT
    MDSYS.ST_UNION(
        (SELECT stgeom FROM myst_country_boundaries WHERE cntry_name = 'Czech Republic'),
        (SELECT stgeom FROM myst_country_boundaries WHERE cntry_name = 'Slovakia')
    ).ST_AREA() AS powierzchnia
FROM dual;

-- Ćwiczenie 4E
SELECT
    MDSYS.ST_DIFFERENCE(
        (SELECT stgeom FROM myst_country_boundaries WHERE cntry_name = 'Hungary'),
        (SELECT MDSYS.ST_MULTIPOLYGON(geom)
         FROM water_bodies
         WHERE name = 'Balaton')
    ).ST_GEOMETRYTYPE() AS obiekt_wegry_bez
FROM dual;

-- Ćwiczenie 5A
SELECT
    b.cntry_name AS a_name,
    COUNT(*)
FROM myst_major_cities c
JOIN myst_country_boundaries b
ON SDO_WITHIN_DISTANCE(
    c.stgeom.GET_SDO_GEOM(),
    b.stgeom.GET_SDO_GEOM(),
    'DISTANCE=100 UNIT=KM'
) = 'TRUE'
WHERE b.cntry_name = 'Poland'
GROUP BY b.cntry_name;

-- Ćwiczenie 5B
INSERT INTO user_sdo_geom_metadata
VALUES (
    'MYST_MAJOR_CITIES',
    'STGEOM',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', -180, 180, 0.01),
        MDSYS.SDO_DIM_ELEMENT('Y', -90, 90, 0.01)
    ),
    8307
);

INSERT INTO user_sdo_geom_metadata
VALUES (
    'MYST_COUNTRY_BOUNDARIES',
    'STGEOM',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', -180, 180, 0.01),
        MDSYS.SDO_DIM_ELEMENT('Y', -90, 90, 0.01)
    ),
    8307
);

COMMIT;

-- Ćwiczenie 5C
CREATE INDEX myst_major_cities_idx
ON myst_major_cities(stgeom)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

CREATE INDEX myst_country_boundaries_idx
ON myst_country_boundaries(stgeom)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

-- Ćwiczenie 5D
EXPLAIN PLAN FOR
SELECT
    b.cntry_name,
    COUNT(*)
FROM myst_major_cities c
JOIN myst_country_boundaries b
ON SDO_WITHIN_DISTANCE(
    c.stgeom.GET_SDO_GEOM(),
    b.stgeom.GET_SDO_GEOM(),
    'DISTANCE=100 UNIT=KM'
) = 'TRUE'
WHERE b.cntry_name = 'Poland'
GROUP BY b.cntry_name;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
