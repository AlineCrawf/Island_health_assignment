WITH all_diseases AS (
       SELECT
            patient_identifier,
            age,
            unit,
            room,
            bed,
            result,
            treatment,
            'CDI' as disease
        FROM CDI
    UNION ALL
        select
            patient_identifier,
            age,
            unit,
            room,
            bed,
            result,
            treatment,
            'COVID-19' as disease
        FROM COVID19
    UNION ALL
       SELECT
            patient_identifier,
            age,
            unit,
            room,
            bed,
            result,
            treatment,
            'MRSA' as disease
        FROM MRSA
    )
SELECT
    patient_identifier,
    age,
    SUBSTR(unit, INSTR(unit, '-') + 1) AS hospital,
    SUBSTR(unit, 1, INSTR(unit, '-') - 1) AS floor,
    room,
    bed,
    disease,
    result,
    treatment
FROM all_diseases;
