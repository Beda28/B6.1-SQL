# query.sql 실행 결과

2026-09-07 (한국 시간), Dockerfile로 빌드한 MySQL 8.4.11 컨테이너에서 `query.sql`을 처음부터 끝까지 1회 실행했다. 종료 코드는 **0**이며, 15개 쿼리가 모두 성공했다.

## 실행 환경과 명령

- 이미지: `pokemon-sql-log:local` (`mysql:8.4` 기반)
- 컨테이너: `pokemon-sql-results-20260907`
- 데이터베이스 / 접속 계정: `POKEMON` / `pokemon`
- 초기화: `init.sql` → `insert.sql` 순서로 자동 실행
- SQL 실행: 컨테이너 내부 `/sql/query.sql`을 MySQL 클라이언트로 실행

```powershell
docker build -t pokemon-sql-log:local .
docker run -d --name pokemon-sql-results-20260907 -e MYSQL_RANDOM_ROOT_PASSWORD=yes --entrypoint sh pokemon-sql-log:local -c 'echo [client] > /etc/mysql/conf.d/utf8.cnf; echo default-character-set=utf8mb4 >> /etc/mysql/conf.d/utf8.cnf; chmod 644 /etc/mysql/conf.d/utf8.cnf; exec /usr/local/bin/docker-entrypoint.sh mysqld'

# 초기화가 끝난 뒤 접속 확인
docker exec -e MYSQL_PWD=pk1234 pokemon-sql-results-20260907 mysql --default-character-set=utf8mb4 -u pokemon -D POKEMON -e 'SELECT VERSION();'

# 컨테이너 내부 SQL 파일 실행
docker exec -e MYSQL_PWD=pk1234 pokemon-sql-results-20260907 sh -c 'mysql --default-character-set=utf8mb4 -u pokemon -vvv < /sql/query.sql'
```

첫 실행에서는 클라이언트 문자셋 때문에 한글 초기 데이터 입력 시 `ERROR 1406 (22001): Data too long for column 'name' at row 1`이 발생했다. Windows 임시 설정 파일을 마운트한 시도도 파일 권한이 world-writable로 인식되어 MySQL이 설정을 무시했다. 최종 실행은 컨테이너 내부에 `utf8mb4` 클라이언트 설정을 만들고 권한을 `644`로 지정해 해결했다. Dockerfile과 SQL 원본은 수정하지 않았다.

아래 표는 실제 출력 순서와 값을 유지했다. 정렬 기준이 같은 행끼리의 순서는 재실행 시 달라질 수 있다. 1~12번 조회는 13~14번 데이터 변경 전 결과다.

## 1. 공격력 80 이상

```sql
SELECT name, atk 
FROM pokemon 
WHERE atk >= 80 
ORDER BY atk DESC;
```

결과: **9 행**

| name | atk |
| --- | --- |
| 망나뇽 | 134 |
| 괴력몬 | 130 |
| 파르셀 | 95 |
| 라이츄 | 90 |
| 리자몽 | 84 |
| 거북왕 | 83 |
| 이상해꽃 | 82 |
| 폴리곤2 | 80 |
| 꼬마돌 | 80 |

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
SELECT p.name AS pokemon, t.name AS type, pt.type_order 
FROM pokemon p 
INNER JOIN pokemon_type pt ON p.id = pt.pokemon_id 
INNER JOIN type t ON pt.type_id = t.id 
ORDER BY p.id, pt.type_order;
```

결과: **16 행**

| pokemon | type | type_order |
| --- | --- | --- |
| 이상해꽃 | 풀 | 1 |
| 이상해꽃 | 독 | 2 |
| 거북왕 | 물 | 1 |
| 리자몽 | 불꽃 | 1 |
| 리자몽 | 비행 | 2 |
| 폴리곤2 | 노말 | 1 |
| 파르셀 | 물 | 1 |
| 파르셀 | 얼음 | 2 |
| 라이츄 | 전기 | 1 |
| 망나뇽 | 드래곤 | 1 |
| 망나뇽 | 비행 | 2 |
| 팬텀 | 고스트 | 1 |
| 팬텀 | 독 | 2 |
| 괴력몬 | 격투 | 1 |
| 꼬마돌 | 바위 | 1 |
| 꼬마돌 | 땅 | 2 |

## 6. 포켓몬별 기술 조회

```sql
SELECT p.name AS pokemon, s.name AS skill 
FROM pokemon p 
INNER JOIN pokemon_skill ps ON p.id = ps.pokemon_id 
INNER JOIN skill s ON ps.skill_id = s.id 
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
INNER JOIN type t ON pt.type_id = t.id
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
LEFT JOIN skill s ON ps.skill_id = s.id
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
INNER JOIN pokemon p ON pt.pokemon_id = p.id
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
AND skill_id = (SELECT id FROM skill WHERE name = '전기쇼크');
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

## 실행 후 확인

별도 SELECT로 변경 내용을 확인했다.

| 확인 항목 | 실제 결과 |
| --- | --- |
| 10만볼트 (`skill.id = 15`) 위력 | 90 → 95 |
| 라이츄–전기쇼크 관계 (`pokemon_id = 6`, `skill_id = 13`) | 남은 행 0개, 삭제 성공 |
| 라이츄 기술 수 | 4 → 3 |
| 전체 포켓몬–기술 관계 수 | 48 → 47 |
| 생성 인덱스 | `idx_pokemon_atk`, 열 `atk`, `BTREE`, `NON_UNIQUE = 1` |
| 전체 포켓몬 평균 공격력 | 92.3000 |

6번과 8번은 모든 포켓몬이 기술을 갖고 있어 동일한 48행을 반환했다. 12번에서는 평균 공격력 92.3보다 높은 망나뇽, 괴력몬, 파르셀만 조회됐다.

이미 실행한 DB에서 다시 실행하면 13번은 변경 행 0개, 14번은 삭제 행 0개가 되며, 15번은 같은 이름의 인덱스가 존재해 오류가 발생한다. 위 결과를 재현하려면 새 데이터 볼륨을 사용하는 컨테이너에서 실행해야 한다.

### 확인 쿼리 원문과 출력

```text
--------------
SELECT name, power FROM skill WHERE id = 15
--------------

+-------------+-------+
| name        | power |
+-------------+-------+
| 10만볼트    |    95 |
+-------------+-------+
1 row in set (0.00 sec)

--------------
SELECT COUNT(*) AS remaining_relation FROM pokemon_skill WHERE pokemon_id = 6 AND skill_id = 13
--------------

+--------------------+
| remaining_relation |
+--------------------+
|                  0 |
+--------------------+
1 row in set (0.00 sec)

--------------
SELECT COUNT(*) AS raichu_skill_count FROM pokemon_skill WHERE pokemon_id = 6
--------------

+--------------------+
| raichu_skill_count |
+--------------------+
|                  3 |
+--------------------+
1 row in set (0.00 sec)

--------------
SELECT COUNT(*) AS total_skill_relations FROM pokemon_skill
--------------

+-----------------------+
| total_skill_relations |
+-----------------------+
|                    47 |
+-----------------------+
1 row in set (0.00 sec)

--------------
SELECT INDEX_NAME, COLUMN_NAME, NON_UNIQUE, INDEX_TYPE FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = 'POKEMON' AND TABLE_NAME = 'pokemon' AND INDEX_NAME = 'idx_pokemon_atk'
--------------

+-----------------+-------------+------------+------------+
| INDEX_NAME      | COLUMN_NAME | NON_UNIQUE | INDEX_TYPE |
+-----------------+-------------+------------+------------+
| idx_pokemon_atk | atk         |          1 | BTREE      |
+-----------------+-------------+------------+------------+
1 row in set (0.01 sec)

--------------
SELECT AVG(atk) AS avg_atk FROM pokemon
--------------

+---------+
| avg_atk |
+---------+
| 92.3000 |
+---------+
1 row in set (0.00 sec)

Bye
```
