USE POKEMON;
SET NAMES utf8mb4;

-- 1. 공격력 90 이상
SELECT name, atk 
FROM pokemon 
WHERE atk >= 90 
ORDER BY atk DESC;

-- 2. 스피드 TOP 5
SELECT name, spe 
FROM pokemon 
ORDER BY spe DESC LIMIT 5;

-- 3. HP 70 이상
SELECT name, hp 
FROM pokemon 
WHERE hp >= 70 
ORDER BY hp DESC;

-- 4. 위력 90 이상 기술
SELECT name, power 
FROM skill 
WHERE power >= 90 
ORDER BY power DESC;

-- 5. 포켓몬 타입 조회
SELECT p.name AS pokemon, GROUP_CONCAT(t.name ORDER BY pt.type_order SEPARATOR ', ') AS type
FROM pokemon p 
INNER JOIN pokemon_type pt ON p.id = pt.pokemon_id 
INNER JOIN type t          ON pt.type_id = t.id 
GROUP BY p.id, p.name
ORDER BY p.id;

-- 6. 포켓몬별 기술 조회
SELECT p.name AS pokemon, s.name AS skill 
FROM pokemon p 
INNER JOIN pokemon_skill ps ON p.id = ps.pokemon_id 
INNER JOIN skill s          ON ps.skill_id = s.id 
ORDER BY p.name, s.name;

-- 7. 전기 타입 포켓몬
SELECT p.name
FROM pokemon p
INNER JOIN pokemon_type pt ON p.id = pt.pokemon_id
INNER JOIN type t          ON pt.type_id = t.id
WHERE t.name = '전기';

-- 8. 모든 포켓몬과 기술 조회
SELECT p.name AS pokemon, s.name AS skill
FROM pokemon p
LEFT JOIN pokemon_skill ps ON p.id = ps.pokemon_id
LEFT JOIN skill s          ON ps.skill_id = s.id
ORDER BY p.name, s.name;

-- 9. 타입별 포켓몬 수
SELECT t.name AS type, COUNT(pt.pokemon_id) AS pokemon_count
FROM type t
LEFT JOIN pokemon_type pt ON t.id = pt.type_id
GROUP BY t.id, t.name
ORDER BY pokemon_count DESC;

-- 10. 타입별 평균 공격력
SELECT t.name AS type, AVG(p.atk) AS avg_atk
FROM type t
INNER JOIN pokemon_type pt ON t.id = pt.type_id
INNER JOIN pokemon p       ON pt.pokemon_id = p.id
GROUP BY t.id, t.name
ORDER BY avg_atk DESC;

-- 11. 포켓몬별 기술 수
SELECT p.name AS pokemon, COUNT(ps.skill_id) AS skill_count
FROM pokemon p
LEFT JOIN pokemon_skill ps ON p.id = ps.pokemon_id
GROUP BY p.id, p.name
ORDER BY skill_count DESC;

-- 12. 평균 공격력보다 높은 포켓몬
SELECT name, atk
FROM pokemon
WHERE atk > (SELECT AVG(atk) FROM pokemon)
ORDER BY atk DESC;

-- 13. 10만볼트 위력 수정
UPDATE skill
SET power = 95
WHERE name = '10만볼트';

-- 14. 라이츄의 전기쇼크 습득 정보 삭제
DELETE FROM pokemon_skill
WHERE pokemon_id = (SELECT id FROM pokemon WHERE name = '라이츄')
AND   skill_id   = (SELECT id FROM skill   WHERE name = '전기쇼크');

-- 15. 공격력 인덱스 생성
CREATE INDEX idx_pokemon_atk ON pokemon(atk);