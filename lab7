-- Ćwiczenie 1A
CREATE TABLE s6_lrs (
    geom MDSYS.SDO_GEOMETRY
);

-- Ćwiczenie 1B
INSERT INTO s6_lrs
SELECT geom
FROM streets_and_railroads
WHERE SDO_WITHIN_DISTANCE(
    geom,
    (SELECT geom FROM major_cities WHERE city_name = 'Koszalin'),
    'DISTANCE=10 UNIT=KM'
) = 'TRUE';

COMMIT;

-- Ćwiczenie 1C
SELECT
    SDO_GEOM.SDO_LENGTH(geom, 0.01) AS distance,
    SDO_UTIL.GETNUMVERTICES(geom) AS st_numpoints
FROM s6_lrs;

-- Ćwiczenie 1D
UPDATE s6_lrs
SET geom = SDO_LRS.CONVERT_TO_LRS_GEOM(
    geom,
    0,
    SDO_GEOM.SDO_LENGTH(geom, 0.01)
);

COMMIT;

-- Ćwiczenie 1E
INSERT INTO user_sdo_geom_metadata
VALUES (
    'S6_LRS',
    'GEOM',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', -180, 180, 0.01),
        MDSYS.SDO_DIM_ELEMENT('Y', -90, 90, 0.01),
        MDSYS.SDO_DIM_ELEMENT('M', 0, 300, 0.01)
    ),
    8307
);

COMMIT;

-- Ćwiczenie 1F
CREATE INDEX s6_lrs_idx
ON s6_lrs(geom)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

-- Ćwiczenie 2A
SELECT
    SDO_LRS.VALID_MEASURE(geom, 500) AS valid_500
FROM s6_lrs;

-- Ćwiczenie 2B
SELECT
    SDO_LRS.GEOM_SEGMENT_END_PT(geom) AS end_pt
FROM s6_lrs;

-- Ćwiczenie 2C
SELECT
    SDO_LRS.LOCATE_PT(geom, 150) AS km150
FROM s6_lrs;

-- Ćwiczenie 2D
SELECT
    SDO_LRS.CLIP_GEOM_SEGMENT(geom, 120, 160) AS clipped
FROM s6_lrs;

-- Ćwiczenie 2E
SELECT
    SDO_LRS.LOCATE_PT(
        geom,
        SDO_LRS.FIND_MEASURE(
            geom,
            (SELECT geom FROM major_cities WHERE city_name = 'Slupsk'),
            'NEAREST',
            'FORWARD'
        )
    ) AS wjazd_na_s6
FROM s6_lrs;

-- Ćwiczenie 2F
SELECT
    SDO_GEOM.SDO_LENGTH(
        SDO_LRS.OFFSET_GEOM_SEGMENT(
            geom,
            50,
            'LEFT',
            50,
            200
        ),
        0.01
    ) AS koszt
FROM s6_lrs;
