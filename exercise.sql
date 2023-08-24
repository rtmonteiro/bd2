-- 1. Pré-requisitos diretos da disciplina de Sinais e Sistemas (ELE16191)

SELECT title
FROM course
WHERE course_id IN (SELECT prereq_id
                    FROM prereq
                    WHERE course_id = 'ELE16191');

-- 2.Disciplinas que têm CÁLCULO III (MAT15936) como pré-requisito direto

SELECT title
FROM course
WHERE course_id IN (SELECT course_id
                    FROM prereq
                    WHERE prereq_id = 'ELE16191');

-- 3.Pré-requisitos dos pré-requisitos da disciplina ELE16191

SELECT title
FROM course
WHERE course_id IN (SELECT p2.prereq_id
                    FROM prereq p1, prereq p2
                    WHERE p1.prereq_id = p2.course_id 
                      and p1.course_id = 'ELE16191');

-- 4.Disciplinas que têm como pré-requisitos disciplinas que têm MAT15936 como pré-requisito

SELECT title
FROM course
WHERE course_id IN (SELECT p1.course_id
                    FROM prereq p1, prereq p2
                    WHERE p1.prereq_id = p2.course_id 
                      and p2.prereq_id = 'MAT15936');

-- 5.Todas as disciplinas que têm MAT15936 como pré-requisito direto ou indireto

WITH RECURSIVE prerequisites AS (
  SELECT course_id
  FROM prereq
  WHERE prereq_id = 'MAT15936'
  UNION
  SELECT p1.course_id
  FROM prereq p1
    INNER JOIN prerequisites p2 ON p1.prereq_id = p2.course_id
)

SELECT title
FROM course
WHERE course_id IN (SELECT *
                    FROM prerequisites);

-- 6.Disciplinas com número total de disciplinas das quais é pré-requisito direto ou indireto

WITH RECURSIVE p AS (
  SELECT *
  FROM prereq p1
    INNER JOIN prereq p2 ON p1.prereq_id = p2.course_id
  UNION
  SELECT *
  FROM prereq p3
    INNER JOIN p p4 ON p3.prereq_id = p4.prereq_id
)

SELECT c.title
FROM course c
  INNER JOIN p ON p.prereq_id = c.course_id
