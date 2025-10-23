-- ============================================

-- 함수 : 컬럼의 값을 읽어서 연산을 한 결과를 반환
 -- 단일행 함수 : N개의 값을 읽어 N개의 결과 반환
 -- 그룹 함수 : N개의 값을 읽어 연산 후 1개의 결과 반환(합계, 평균, 최대, 최소)

-- 함수는 SELECT 문의 SELECT 절, WHERE 절, ORDER BY 절, HAVING 절 에서 사용 가능


-- 1. 단일 행 함수 - 문자 관련

-- 1) LENGTH(컬럼명 | 문자열) : 길이 반환
 -- EMPLOYEE 테이블에서 모든 사원의 EMAIL 및 EMAIL 길이 조회
SELECT EMAIL, LENGTH(EMAIL) FROM EMPLOYEE;

-- 2) INSTR(컬럼명 | 문자열, '찾을 문자열' [, 찾기 시작할 위치] [, 순번] ) * [] 안은 필수 X
 -- 지정한 위치부터 지정한 순번째로 검색되는 문자의 위치 반환
 
 -- 문자열을 앞에서부터 검색하여 처음으로 검색되는 B '위치' 조회
  -- AABAACAABBAA
  SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL;
 
 -- 문자열을 5번째 문자부터 검색하여 처음으로 검색되는 B 위치 조회
  SELECT INSTR('AABAACAABBAA', 'B', 5) FROM DUAL;

 -- 문자열을 5번째 문자부터 검색하여 두번째로 검색되는 B 위치 조회
  SELECT INSTR('AABAACAABBAA', 'B', 5, 2) FROM DUAL;

 -- EMPLOYEE 테이블에서 이름, 이메일, 이메일 중 '@' 위치 조회
  SELECT EMP_NAME, EMAIL, INSTR(EMAIL, '@') FROM EMPLOYEE;

-- ============================================

-- 3) SUBSTR(컬럼명 | 문자열, 잘라내기 시작할 위치 [, 잘라낼 길이])
 -- 컬럼이나 문자열에서 지정한 위치부터 지정한 길이만큼 문자열 잘라내어 반환
 -- 잘라낼 길이 생략 시 끝까지 잘라냄

 -- EMPLOYEE 테이블에서 사원명, 이메일 중 아이디만 조회
 SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1 ) "ID" FROM EMPLOYEE;

-- ============================================

-- 4) TRIM([[옵션]문자열 | 컬럼명 FROM) 컬럼명 | 문자열)
 -- 주어진 컬럼이나 문자열의 앞, 뒤, 양쪽에 있는 지정된 문자 제거
 --> 양쪽 공백 제거에 주로 사용
 -- [옵션] : LEADING(앞쪽), TRAILING(뒤쪽), BOTH(양쪽, 기본값)

 SELECT TRIM('    H E L L O    ') FROM DUAL; -- 공백 제거
 SELECT TRIM(BOTH '#' FROM '####안녕####') FROM DUAL; -- # 제거
 SELECT TRIM(TRAILING '#' FROM '####안녕####') FROM DUAL; -- # 제거
 SELECT TRIM(LEADING '#' FROM '####안녕####') FROM DUAL; -- # 제거

-- ============================================

-- 2. 단일 행 함수 - 숫자 관련
 
 -- 1) ABS(숫자 | 컬럼명) : 절대값
  SELECT ABS(-10) FROM DUAL;
  SELECT '절대값 같음' FROM DUAL WHERE ABS(10) = ABS(-10);

 -- 2) MOD(숫자 | 컬럼명, 숫자 | 컬럼명) 나머지 값 반환
  -- EMPLOYEE 테이블에서 사원 월급을 100만으로 나누었을 때 나머지값 조회
  SELECT EMP_NAME, SALARY, MOD(SALARY, 1000000) FROM EMPLOYEE;

  -- EMPLOYEE 테이블에서 사번이 짝수인 사원의 사번, 이름 조회
  SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE MOD(EMP_ID, 2) = 0;
  SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE MOD(EMP_ID, 2) <> 0;

 --3) ROUND(숫자 | 컬럼명 [, 소수점 위치]) : 반올림
  -- 소수점 위치 미 작성 시 소수점 첫번째 자리에서 반올림
  SELECT ROUND(123.456) FROM DUAL;
  SELECT ROUND(123.456, 2) FROM DUAL; -- 소수점 세번째 자리에서 반올림하여 소수점 둘째자리까지 표시)	
	
	-- CEIL(숫자 | 컬럼명) : 올림
	-- FLOOR(숫자 | 컬럼명) : 내림
	 -- 둘 모두 소수점 첫째 자리에서 올림/내림 처리
	SELECT CEIL(123.1), FLOOR(239.8) FROM DUAL;

	-- TRUNC(숫자 | 컬럼명 [,위치])) : 특정 위치 아래 절삭
	SELECT TRUNC(123.456) FROM DUAL; -- 소수점 아래 전부 절삭
	SELECT TRUNC(123.456, 1) FROM DUAL; -- 소수점 첫째 자리 아래 전부 절삭
	
-- ============================================
	
-- 날짜(DATE) 관련 함수
	
 -- SYSDATE : 시스템 상 현재 시간(년, 월, 일, 시, 분, 초)
 SELECT SYSDATE FROM DUAL; -- 2025-10-23 15:11:41.000
 
 -- SYSTIMESTAMP : SYSDATE + MS 단위 추가(UTC 정보)
 SELECT SYSTIMESTAMP FROM DUAL; -- 2025-10-23 15:13:15.704 +0900
 
 -- MONTHS_BETWEEN(날짜, 날짜) : 두 날짜의 개월 수 차이 반환
 SELECT MONTHS_BETWEEN(SYSDATE, '2026-02-27') "수강 기간(개월)" FROM DUAL; -- -4.10853307945041816009557945041816009558
 SELECT ROUND(MONTHS_BETWEEN(SYSDATE, '2026-02-27'), 1) "수강 기간(개월)" FROM DUAL; -- -4.1 (반올림)
 SELECT ABS(ROUND(MONTHS_BETWEEN(SYSDATE, '2026-02-27'), 1)) "수강 기간(개월)" FROM DUAL; -- 4.1 (절대값)
 
 -- EMPLOYEE 테이블에서 이름, 입사일, 근무 개월 수, 근무년차 조회
 SELECT EMP_NAME, HIRE_DATE, 
	CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무 개월 수", 
	CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12) || '년차' "근무년차" -- || : 연결 연산자(문자열 이어쓰기)
	FROM EMPLOYEE;

-- ADD_MONTHS(날짜, 숫자) : 날짜에 숫자만큼의 개월 수를 더함 (음수도 가능)
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL; -- 2026-02-23 15:25:38.000
SELECT ADD_MONTHS(SYSDATE, -1) FROM DUAL; -- 2025-09-23 15:26:16.000

-- LAST_DAY(날짜) : 해당 달의 마지막 날짜 구함
SELECT LAST_DAY(SYSDATE) FROM DUAL; -- 2025-10-31 15:27:22.000
SELECT LAST_DAY('2020-02-01') FROM DUAL; -- 2020-02-29 00:00:00.000

-- EXTRACT() : 년, 월, 일 정보를 추출해 반환
 -- EXTRACT(YEAR FROM 날짜) : 연도만 추출
 SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;
 
 -- EMPLOYEE 테이블에서 이름, 입사일 조회(연도, 월, 일))
 SELECT EMP_NAME, 
  EXTRACT(YEAR FROM HIRE_DATE) || '년 ' ||
  EXTRACT(MONTH FROM HIRE_DATE) || '월 ' ||
  EXTRACT(DAY FROM HIRE_DATE) || '일' AS "입사일"
  FROM EMPLOYEE;
 
-- ============================================

-- 형변환 함수

 -- 문자열(CHAR), 숫자(NUMBER), 날짜(DATE) 끼리 형변환 가능
 -- 문자열로 변환
	-- TO_CHAR(날짜, [포맷]) : 날짜형 > 문자형 	
	-- TO_CHAR(숫자, [포맷]) : 숫자형 > 문자형

 -- 숫자 > 문자 변환 시 포맷 패턴
  -- 9 : 숫자 한칸을 의미, 여러 개 작성 시 오른쪽 정렬
	-- 0 : 숫자 한칸을 의미, 여러 개 작성 시 오른쪽 정렬 + 빈칸은 0으로 추가
	-- L : 현재 DB에 설정된 나라의 화폐 기호
 SELECT 1234 FROM DUAL;
 SELECT TO_CHAR(1234) FROM DUAL; -- 컬럼명에 마우스를 대보면 VARCHAR2 로 변경된 것을 확인 가능
 SELECT TO_CHAR(1234, '99999') FROM DUAL; -- 5자리의 문자형 변환 후 맨 왼쪽은 빈칸 + 오른쪽 정렬 ' 1234'
 SELECT TO_CHAR(1234, '00000') FROM DUAL; -- 5자리의 문자형 변환 후 맨 왼쪽은 0 + 오른쪽 정렬 ' 01234'
 SELECT TO_CHAR(1000000, '9,999,999') || '원' FROM DUAL; --  1,000,000원
 SELECT TO_CHAR(1000000, 'L9,999,999') FROM DUAL; -- '￦1,000,000'
 
 -- 날짜 > 문자 변환 시 포맷 패턴
  -- YYYY : 년도 / YY : 년도(짧게)
  -- MM : 월
  -- DD : 일
  -- AM 또는 PM : 오전/오후
  -- HH : 시간 / HH24 : 24시간 표기법
	-- MI : 분 / SS: 초
  -- DAY : 요일 전체 / DY : 요일명만 표시
 SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS DAY') FROM DUAL; -- 2025/10/23 16:12:53 목요일
 SELECT TO_CHAR(SYSDATE, 'MM/DD (DY)') FROM DUAL; -- 10/23 (목)
 SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" (DY)') FROM DUAL; -- 포맷 안에 특정 글자를 문자로 인식시키기 위해서는 쌍따옴표 필요 -- 2025년 10월 23일 (목)
 
 -- 날짜로 변환 : TO_DATE
  -- TO_DATE(문자, [포맷]) : 문자형 > 날짜형
  -- TO_DATE(숫자, [포맷]) : 숫자형 > 날짜형
 	 -- > 지정된 포맷으로 날짜를 인식함
 
 SELECT TO_DATE('2025-10-23') FROM DUAL;
 SELECT TO_DATE(20251023) FROM DUAL;

 SELECT TO_DATE('251020 101730', 'YYMMDD HH24MISS') FROM DUAL; -- 2025-10-20 10:17:30.000
  -- 이런 경우는 반드시 패턴을 적용시켜주어야 인식할 수 있다.
 
 -- Y 패턴 : 현재 세기(21세기 = 20XX년도 = 2000년대)
 -- R 패턴 : 1세기 기준으로 절반(50년) 이상인 경우 이전 세기(1900년대), 절반(50년) 미만인 경우 현재 세기(2000년대)
 SELECT TO_DATE('800505', 'YYMMDD') FROM DUAL; -- 2080-05-05 00:00:00.000
 SELECT TO_DATE('800505', 'RRMMDD') FROM DUAL; -- 1980-05-05 00:00:00.000
 SELECT TO_DATE('490505', 'RRMMDD') FROM DUAL; -- 2049-05-05 00:00:00.000
 
 -- EMPLOYEE 테이블에서 각 직원이 태어난 생년월일 조회
  -- 사원이름, 생년월일 (1965년 10월 08일)
  -- 1) 주민번호(EMP_NO)에서 - 앞글자까지 추출	
   SELECT EMP_NAME, 
	 SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-')-1) AS "생년월일" 
	 FROM EMPLOYEE; 
 
  -- 2) 추출한 생년월일을 TO_DATE 타입으로 변경 -> RR 패턴 이용해 1900년대로 바꾸어어주고 -> TO_CHAR 로 문자열 패턴으로 바꾼다.
	 SELECT EMP_NAME, 
	 TO_CHAR(TO_DATE( SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-')-1), 'RRMMDD'), 'YYYY"년" MM"월" DD"일"') AS "생년월일"
	 FROM EMPLOYEE; 

-- 숫자 형변환
 -- TO_NUMBER(문자데이터, [포맷]) : 문자형 데이터를 숫자 데이터로 변경
 SELECT '1000000' + 500000 FROM DUAL;
 SELECT '1,000,000' + 500000 FROM DUAL; -- ORA-01722: 수치가 부적합합니다 -> 형변환 필요
 SELECT TO_NUMBER('1,000,000', '9,999,999') + 500000 FROM DUAL;
 
 -- 날짜 > 숫자로 변환 시, 
  -- 날짜 > 문자 > 숫자의 과정을 거쳐야 함. TO_CAHR(날짜) > TO_NUMBER(문자)

-- ==================================================================

-- MULL 처리 함수
 -- NVL(컬럼명, 컬럼값이 NULL일 때 바꿀 값) : NULL인 컬럼값을 다른 값으로 변경

 SELECT EMP_NAME, SALARY, NVL(BONUS, 0), SALARY * NVL(BONUS, 0) FROM EMPLOYEE; -- NVL(BONUS, 0) : BOUNS 의 NULL 을 0 으로 바꾸겠다.
 -- NULL 산술 연산 시 결과는 무조건 NULL 이다.

 -- NVL2(컬럼명, 바꿀값1, 바꿀값2)
  -- 해당 컬럼의 값이 있으면 바꿀값1, NULL이면 바꿀값2 로 변경
 -- EMPLOYEE 테이블에서 보너스 받으면 '0', 받지 않으면 'X'
 SELECT EMP_NAME, NVL2(BONUS, 'O', 'X') "보너스 유무" FROM EMPLOYEE;

-- ==================================================================

-- 선택 함수
 -- 여러가지 경우에 따라 알맞은 결과를 선택할 수 있음

 -- DECODE(계산식 | 컬럼명, 조건값1, 선택값1, 조건값2, 선택값2, ..... , 아무것도 일치하지 않을 때)
 -- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과값 반환

 -- 직원 성별 구하기
 SELECT EMP_NAME, 
 DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남성', 2, '여성')  성별 FROM EMPLOYEE;

 -- 직원 급여 인상하기
  -- 직급 코드가 J7 인 직원 20% 인상
  -- 직급 코드가 J6 인 직원 15% 인상
  -- 직급 코드가 J5 인 직원 10% 인상
  -- 그 외 직급 5% 인상
  -- 이름, 직급코드, 급여, 인상률, 인상된 급여 조회

 SELECT EMP_NAME, JOB_CODE, SALARY,
 DECODE(JOB_CODE, 'J7', '20%', 'J6', '15%','J5', '10%', '5%') AS "인상률",
 DECODE(JOB_CODE, 'J7', SALARY * 1.2, 'J6', SALARY * 1.15,'J5', SALARY * 1.1, SALARY * 1.05) AS "인상된 급여"
 FROM EMPLOYEE;
 
-- CASE 표현식 (JAVA 의 IF 문과 비슷)
 -- CASE WHEN 조건식 THEN 결과값
 -- 		  WHEN 조건식 THEN 결과값
 -- 			ELSE 결과값
 --	END

 -- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과값 반환
 -- 조건은 범위 값 가능
 
 -- EMPLOYEE 테이블에서, 급여 500 이상이면 '대', 300 ~ 500 '중', 300 미만 '소'로 조회
 SELECT EMP_NAME, SALARY, 
	 CASE WHEN SALARY >= 5000000 THEN '대'
	 			WHEN SALARY < 5000000 AND SALARY >= 3000000 THEN '중'
	 			ELSE '소' 
				END "급여 정도"
 FROM EMPLOYEE;

-- ==================================================================

-- 그룹함수
 -- 하나 이상의 행을 그룹으로 묶어 연산하여 총합, 평균 등의 1개의 결과 행으로 반환

 -- SUM(숫자가 기록된 컬럼명) : 계
 -- 모든 직원 급여 합 조회
 SELECT SUM(SALARY) FROM EMPLOYEE;
 
 -- AVG(숫자가 기록된 컬럼명) : 평균
 -- 모든 직원 평균 급여 조회
 SELECT ROUND(AVG(SALARY)) FROM EMPLOYEE;

 -- 부서코드가 'D9' 인 사원들의 급여 합, 평균 조회
 SELECT SUM(SALARY), ROUND(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = 'D9';
  -- 순서 : 1. FROM, 2. WHERE, 3. SELECT
 
 -- MIN(컬럼명) : 최소값
 -- MAX(컬럼명) : 최대값
  -- > 타입의 제한이 없다 ( 숫자 : 대/소, 날짜 : 과거/미래, 문자열 : 문자 순서(오름차순 또는 내림차순) )

 -- 급여 최소/최대값, 가장빠른/느린 입사일, 알파벳 순서가 가장 빠른/느린 이메일 조회
 SELECT MIN(SALARY), MIN(HIRE_DATE), MIN(EMAIL) FROM EMPLOYEE;
 SELECT MAX(SALARY), MAX(HIRE_DATE), MAX(EMAIL) FROM EMPLOYEE;

 -- EMPLOYEE 테이블에서 급여를 가장 많이 받는 사원의 이름, 급여, 직급 코드 조회
 SELECT MAX(SALARY) FROM EMPLOYEE; -- 서브쿼리
 SELECT EMP_NAME, SALARY, JOB_CODE FROM EMPLOYEE WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE); -- 서브쿼리를 WHERE 절에 활용한다. 뒤에서 배움
 
 -- COUNT() : 행 개수를 반환
 -- COUNT(컬럼명) : NULL 제외한 실제값이 기록된 행 개수 반환
 -- COUNT(*) : NULL 포함한 전체 행 개수 반환
 -- COUNT(DISTINCT 컬럼명) : 중복 제거한 행 개수 반환
 SELECT COUNT(*) FROM EMPLOYEE;
 SELECT COUNT(SALARY) FROM EMPLOYEE;
 SELECT COUNT(BONUS) FROM EMPLOYEE;
 SELECT COUNT(DISTINCT JOB_CODE) FROM EMPLOYEE;
 
 
 
