-- PASSOS
-- 1. Entra como postgres e cria os usuários
CREATE ROLE <user> PASSWORD '<password>';
-- 2. Entra como dba e da as permissões para dar permissão para u1, u2, u3
GRANT <permission> ON <table> TO <user>;
-- 3. Entra como u1 e testa as permissões
-- 4. Como u1, criar u4 herdando de u1
CREATE USER u4 IN ROLE u1;

-- Usuários e permissões
-- u1 - course
-- u2 - department
-- u3 - prereq


-- Cria o usuário u1 com senha u1
CREATE USER u1 PASSWORD 'u1';

-- Cria a role course
CREATE ROLE course
PASSWORD 'course';

-- Definir permissoes para o usuario u1
GRANT SELECT ON course TO u1;

-- Definir u4 como herdado de u1
CREATE USER u4 IN ROLE u1;

------------------------------------------------------------
-- Cria o usuário u2 com senha u2
CREATE USER u2 PASSWORD 'u2';

-- Cria o usuário u3 com senha u3
CREATE USER u3 PASSWORD 'u3';

-- Definir u4 como herdado de u1
CREATE USER u4 IN ROLE u1;
