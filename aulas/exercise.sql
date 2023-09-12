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
  UNION ALL
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
  SELECT course_id, prereq_id
  FROM prereq
  UNION
  SELECT p3.*
  FROM prereq p3
    INNER JOIN p p4 ON p3.prereq_id = p4.prereq_id
), count_prereq AS (
  SELECT course_id, COUNT(*) AS qtd_prereq
  FROM p
  GROUP BY course_id
)

SELECT c.title, count_prereq.qtd_prereq
FROM course c
  INNER JOIN count_prereq ON count_prereq.course_id = c.course_id
ORDER BY qtd_prereq DESC

-- 6.1

WITH RECURSIVE p AS (
  SELECT prereq_id AS course_id, course_id AS dependent_id
  FROM prereq

  UNION

  SELECT p.course_id, p2.course_id
  FROM p JOIN prereq p2 ON p2.prereq_id = p.dependent_id
)

SELECT course.title, COUNT(*)
FROM p JOIN course ON p.course_id = course.course_id
GROUP BY course.title
ORDER BY p.count desc
