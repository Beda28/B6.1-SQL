```sql
USE POKEMON;
SET NAMES utf8mb4;
```

## 1. 공격력 90 이상

```sql
SELECT name, atk 
FROM pokemon 
WHERE atk >= 90 
ORDER BY atk DESC;
```

결과: **4 행**

| name | atk |
| --- | --- |
| 망나뇽 | 134 |
| 괴력몬 | 130 |
| 파르셀 | 95 |
| 라이츄 | 90 |

## 2. 스피드 TOP 5

```sql
SELECT name, spe 
FROM pokemon 
ORDER BY spe DESC LIMIT 5;
```

결과: **5 행**

| name | spe |
| --- | --- |
| 라이츄 | 110 |
| 팬텀 | 110 |
| 리자몽 | 100 |
| 이상해꽃 | 83 |
| 망나뇽 | 80 |

## 3. HP 70 이상

```sql
SELECT name, hp 
FROM pokemon 
WHERE hp >= 70 
ORDER BY hp DESC;
```

결과: **6 행**

| name | hp |
| --- | --- |
| 망나뇽 | 91 |
| 괴력몬 | 90 |
| 폴리곤2 | 85 |
| 이상해꽃 | 80 |
| 거북왕 | 79 |
| 리자몽 | 78 |

## 4. 위력 90 이상 기술

```sql
SELECT name, power 
FROM skill 
WHERE power >= 90 
ORDER BY power DESC;
```

결과: **15 행**

| name | power |
| --- | --- |
| 자폭 | 200 |
| 파괴광선 | 150 |
| 솔라빔 | 120 |
| 전자포 | 120 |
| 하이드로펌프 | 110 |
| 번개 | 110 |
| 폭풍 | 110 |
| 드래곤다이브 | 100 |
| 크로스촙 | 100 |
| 폭발펀치 | 100 |
| 지진 | 100 |
| 오물폭탄 | 90 |
| 화염방사 | 90 |
| 냉동빔 | 90 |
| 10만볼트 | 90 |

## 5. 포켓몬 타입 조회

```sql
SELECT p.name AS pokemon, GROUP_CONCAT(t.name ORDER BY pt.type_order SEPARATOR ', ') AS type
FROM pokemon p 
INNER JOIN pokemon_type pt ON p.id = pt.pokemon_id 
INNER JOIN type t          ON pt.type_id = t.id 
GROUP BY p.id, p.name
ORDER BY p.id;
```

결과: **10 행**

| pokemon | type |
| --- | --- |
| 이상해꽃 | 풀, 독 |
| 거북왕 | 물 |
| 리자몽 | 불꽃, 비행 |
| 폴리곤2 | 노말 |
| 파르셀 | 물, 얼음 |
| 라이츄 | 전기 |
| 망나뇽 | 드래곤, 비행 |
| 팬텀 | 고스트, 독 |
| 괴력몬 | 격투 |
| 꼬마돌 | 바위, 땅 |

## 6. 포켓몬별 기술 조회

```sql
SELECT p.name AS pokemon, s.name AS skill 
FROM pokemon p 
INNER JOIN pokemon_skill ps ON p.id = ps.pokemon_id 
INNER JOIN skill s          ON ps.skill_id = s.id 
ORDER BY p.name, s.name;
```

결과: **48 행**

| pokemon | skill |
| --- | --- |
| 거북왕 | 고속스핀 |
| 거북왕 | 냉동빔 |
| 거북왕 | 몸통박치기 |
| 거북왕 | 물대포 |
| 거북왕 | 하이드로펌프 |
| 괴력몬 | 로킥 |
| 괴력몬 | 지구던지기 |
| 괴력몬 | 지진 |
| 괴력몬 | 크로스촙 |
| 괴력몬 | 폭발펀치 |
| 꼬마돌 | 돌떨구기 |
| 꼬마돌 | 록블라스트 |
| 꼬마돌 | 몸통박치기 |
| 꼬마돌 | 자폭 |
| 꼬마돌 | 지진 |
| 라이츄 | 10만볼트 |
| 라이츄 | 번개 |
| 라이츄 | 전광석화 |
| 라이츄 | 전기쇼크 |
| 리자몽 | 베어가르기 |
| 리자몽 | 불꽃세례 |
| 리자몽 | 에어슬래시 |
| 리자몽 | 파괴광선 |
| 리자몽 | 화염방사 |
| 망나뇽 | 10만볼트 |
| 망나뇽 | 드래곤다이브 |
| 망나뇽 | 용의꼬리 |
| 망나뇽 | 전광석화 |
| 망나뇽 | 파괴광선 |
| 망나뇽 | 폭풍 |
| 이상해꽃 | 몸통박치기 |
| 이상해꽃 | 솔라빔 |
| 이상해꽃 | 오물폭탄 |
| 이상해꽃 | 잎날가르기 |
| 파르셀 | 고드름침 |
| 파르셀 | 냉동빔 |
| 파르셀 | 얼음뭉치 |
| 파르셀 | 오로라빔 |
| 파르셀 | 하이드로펌프 |
| 팬텀 | 10만볼트 |
| 팬텀 | 섀도볼 |
| 팬텀 | 섀도펀치 |
| 팬텀 | 오물폭탄 |
| 팬텀 | 핥기 |
| 폴리곤2 | 10만볼트 |
| 폴리곤2 | 몸통박치기 |
| 폴리곤2 | 전자포 |
| 폴리곤2 | 트라이어택 |

## 7. 전기 타입 포켓몬

```sql
SELECT p.name
FROM pokemon p
INNER JOIN pokemon_type pt ON p.id = pt.pokemon_id
INNER JOIN type t          ON pt.type_id = t.id
WHERE t.name = '전기';
```

결과: **1 행**

| name |
| --- |
| 라이츄 |

## 8. 모든 포켓몬과 기술 조회

```sql
SELECT p.name AS pokemon, s.name AS skill
FROM pokemon p
LEFT JOIN pokemon_skill ps ON p.id = ps.pokemon_id
LEFT JOIN skill s          ON ps.skill_id = s.id
ORDER BY p.name, s.name;
```

결과: **48 행**

| pokemon | skill |
| --- | --- |
| 거북왕 | 고속스핀 |
| 거북왕 | 냉동빔 |
| 거북왕 | 몸통박치기 |
| 거북왕 | 물대포 |
| 거북왕 | 하이드로펌프 |
| 괴력몬 | 로킥 |
| 괴력몬 | 지구던지기 |
| 괴력몬 | 지진 |
| 괴력몬 | 크로스촙 |
| 괴력몬 | 폭발펀치 |
| 꼬마돌 | 돌떨구기 |
| 꼬마돌 | 록블라스트 |
| 꼬마돌 | 몸통박치기 |
| 꼬마돌 | 자폭 |
| 꼬마돌 | 지진 |
| 라이츄 | 10만볼트 |
| 라이츄 | 번개 |
| 라이츄 | 전광석화 |
| 라이츄 | 전기쇼크 |
| 리자몽 | 베어가르기 |
| 리자몽 | 불꽃세례 |
| 리자몽 | 에어슬래시 |
| 리자몽 | 파괴광선 |
| 리자몽 | 화염방사 |
| 망나뇽 | 10만볼트 |
| 망나뇽 | 드래곤다이브 |
| 망나뇽 | 용의꼬리 |
| 망나뇽 | 전광석화 |
| 망나뇽 | 파괴광선 |
| 망나뇽 | 폭풍 |
| 이상해꽃 | 몸통박치기 |
| 이상해꽃 | 솔라빔 |
| 이상해꽃 | 오물폭탄 |
| 이상해꽃 | 잎날가르기 |
| 파르셀 | 고드름침 |
| 파르셀 | 냉동빔 |
| 파르셀 | 얼음뭉치 |
| 파르셀 | 오로라빔 |
| 파르셀 | 하이드로펌프 |
| 팬텀 | 10만볼트 |
| 팬텀 | 섀도볼 |
| 팬텀 | 섀도펀치 |
| 팬텀 | 오물폭탄 |
| 팬텀 | 핥기 |
| 폴리곤2 | 10만볼트 |
| 폴리곤2 | 몸통박치기 |
| 폴리곤2 | 전자포 |
| 폴리곤2 | 트라이어택 |

## 9. 타입별 포켓몬 수

```sql
SELECT t.name AS type, COUNT(pt.pokemon_id) AS pokemon_count
FROM type t
LEFT JOIN pokemon_type pt ON t.id = pt.type_id
GROUP BY t.id, t.name
ORDER BY pokemon_count DESC;
```

결과: **13 행**

| type | pokemon_count |
| --- | --- |
| 독 | 2 |
| 물 | 2 |
| 비행 | 2 |
| 격투 | 1 |
| 고스트 | 1 |
| 노말 | 1 |
| 드래곤 | 1 |
| 땅 | 1 |
| 바위 | 1 |
| 불꽃 | 1 |
| 얼음 | 1 |
| 전기 | 1 |
| 풀 | 1 |

## 10. 타입별 평균 공격력

```sql
SELECT t.name AS type, AVG(p.atk) AS avg_atk
FROM type t
INNER JOIN pokemon_type pt ON t.id = pt.type_id
INNER JOIN pokemon p       ON pt.pokemon_id = p.id
GROUP BY t.id, t.name
ORDER BY avg_atk DESC;
```

결과: **13 행**

| type | avg_atk |
| --- | --- |
| 드래곤 | 134.0000 |
| 격투 | 130.0000 |
| 비행 | 109.0000 |
| 얼음 | 95.0000 |
| 전기 | 90.0000 |
| 물 | 89.0000 |
| 불꽃 | 84.0000 |
| 풀 | 82.0000 |
| 노말 | 80.0000 |
| 땅 | 80.0000 |
| 바위 | 80.0000 |
| 독 | 73.5000 |
| 고스트 | 65.0000 |

## 11. 포켓몬별 기술 수

```sql
SELECT p.name AS pokemon, COUNT(ps.skill_id) AS skill_count
FROM pokemon p
LEFT JOIN pokemon_skill ps ON p.id = ps.pokemon_id
GROUP BY p.id, p.name
ORDER BY skill_count DESC;
```

결과: **10 행**

| pokemon | skill_count |
| --- | --- |
| 망나뇽 | 6 |
| 거북왕 | 5 |
| 괴력몬 | 5 |
| 꼬마돌 | 5 |
| 리자몽 | 5 |
| 파르셀 | 5 |
| 팬텀 | 5 |
| 라이츄 | 4 |
| 이상해꽃 | 4 |
| 폴리곤2 | 4 |

## 12. 평균 공격력보다 높은 포켓몬

```sql
SELECT name, atk
FROM pokemon
WHERE atk > (SELECT AVG(atk) FROM pokemon)
ORDER BY atk DESC;
```

결과: **3 행**

| name | atk |
| --- | --- |
| 망나뇽 | 134 |
| 괴력몬 | 130 |
| 파르셀 | 95 |

## 13. 10만볼트 위력 수정

```sql
UPDATE skill
SET power = 95
WHERE name = '10만볼트';
```

```text
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0
```

## 14. 라이츄의 전기쇼크 습득 정보 삭제

```sql
DELETE FROM pokemon_skill
WHERE pokemon_id = (SELECT id FROM pokemon WHERE name = '라이츄')
AND   skill_id   = (SELECT id FROM skill   WHERE name = '전기쇼크');
```

```text
Query OK, 1 row affected (0.00 sec)
```

## 15. 공격력 인덱스 생성

```sql
CREATE INDEX idx_pokemon_atk ON pokemon(atk);
```

```text
Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0
```
