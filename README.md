# 6-1. SQL

Docker Desktop을 켜고 PowerShell에서 실행한다.

## 1. 폴더 이동 및 이미지 빌드

```powershell
cd "C:\Users\ozekr\OneDrive\Desktop\Codyssey\AI, SW Basic\6-1. SQL"
docker build -t pokemon-sql:local .
```

## 2. 컨테이너 실행

```powershell
docker run -d --name pokemon-practice -e MYSQL_RANDOM_ROOT_PASSWORD=yes pokemon-sql:local
```

## 3. MySQL 접속

초기화가 끝난 뒤 실행한다.

```powershell
docker exec -it pokemon-practice mysql -u pokemon -p POKEMON
```

비밀번호: `pk1234`

## 4. 복사된 query.sql 실행

MySQL 접속 후 `mysql>`에서 입력한다.

```sql
SET NAMES utf8mb4;
SOURCE /sql/query.sql;
```
