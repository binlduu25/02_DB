/*
 * ===== SELECT (DML 또는 DQL) : 조회 =====
 * 
 * - 데이터를 조회(SELECT)하면 조건에 맞는 행들이 조회됨. 이때, 조회된 행들의 집합을 "RESULT SET" 이라고 한다.
 * - RESULT SET 은 '0'개 이상의 행을 포함할 수 있다. 즉 아예 없을 수도 있다. 조건에 맞는 행이 하나도 없을 수 있기 때문
 * 
 * [작성법]   
 * SELECT 컬럼명 FROM 테이블명;
 *  -> 테이블의 특정 컬럼을 조회하겠다.
 * 
 * */

-- ===============================================================================

-- 1. 조회 연습

SELECT * FROM EMPLOYEE;
-- * 은 '모든'을 뜻한다.
 -- 위 명령어는 EMPLOYEE 테이블에서 모든 컬럼을 조회하겠다는 뜻

-- 만약, EMPLOYEE 테이블에서 사번, 이름, 전화번호만 조회하고 싶을 때
 -- 컬럼 간의 구분은 콤마로 한다.
 -- 컬럼명을 정확하게 알고 있어야 한다. 
 SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE;

-- ===============================================================================

-- 2. 컬럼 값 산술 연산

 -- 컬럼 값 :  테이블 내 한 칸(한 셀)에 작성된 값(DATA)
 
 -- EMPLOYEE 테이블에서 모든 사원의 사번, 이름, 급여, "연봉" 조회
  -- 테이블에 연봉 값은 없고 월급은 있으므로 해당 컬럼값에 12를 곱한다.
 	SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 FROM EMPLOYEE;
  
 SELECT EMP_NAME + 10 FROM EMPLOYEE;
 -- 해당 명령어 수행의 경우 이름에다 10을 더하는 건 오류가 발생한다.
  -- 즉 NUMBER 타입에만 산술연산이 가능하다.
	
 SELECT '같음' FROM DUAL WHERE 1 = '1';
 -- DUAL : DUmmy tAbLe (가짜 테이블, 또는 임시 조회용 테이블)
  -- 더미 테이블에서 '같음'을 조회하는데 숫자 1과 문자열 1이 같을 때만 조회(?)
  -- 즉 '' 안에서 숫자만 있는 경우 문자열 타입이어도 자동으로 형변환 되어 숫자로 인식한다.
 
 SELECT EMP_ID + 10 FROM EMPLOYEE;
 -- EMP ID는 VARCHAR2 타입이어서 문자지만 안의 DATA가 모두 숫자이기에 위 명령어 수행이 가능하다.

-- ===============================================================================

-- 3. 날짜(DATE) 타입 조회
 -- EMPLOYEE 테이블에서 이름, 입사일, 오늘 날짜 조회
 SELECT EMP_NAME, HIRE_DATE, SYSDATE FROM EMPLOYEE;
  -- SYSDATE : 오늘 날짜 (2025-10-23 10:10:53.000), 시스템상의 현재 시간(날짜)를 나타내는 상수

 -- 더미데이터에서 오늘 날짜 조회
 SELECT SYSDATE FROM DUAL; 
   
 -- 날짜 + 산술연산 (+,-)
 SELECT SYSDATE - 1, SYSDATE, SYSDATE + 1 FROM DUAL;
  -- 날짜에 +,- 연산 시 '일' 단위로 계산됨

-- 4. 컬럼 별칭 지정 
 SELECT SYSDATE - 1, SYSDATE, SYSDATE + 1 FROM DUAL;
 -- 위 경우처럼 조회 시 컬럼명이 입력한 대로 나오게 된다. 이를 따로 지정해주고 싶을 때,
  -- 컬럼명 AS 별칭 : 띄어쓰기 불가, 특수문자 불가, 문자만 가능
  -- 컬럼명 AS "별칭" : 띄어쓰기 가능, 특수문자 가능, 문자만 가능
  -- AS 생략 가능
 SELECT SYSDATE - 1 "하루 전", SYSDATE AS 현재시간, SYSDATE + 1 내일 FROM DUAL;

-- ===============================================================================

-- JAVA에서 리터럴은 값 자체를 의미한다. 
 -- EX) long long = 222;

-- DB에서 리터럴은 임의로 지정한 값을 기존 테이블에 존재하는 값처럼 사용하는 것
 -- 임의로 지정한 값을 기존 테이블에 존재하는 값처럼 사용(조회)하는 것
  --> DB의 리터럴 표기법은 '' 홑따옴표
 SELECT EMP_NAME, SALARY, '원 입니다' FROM EMPLOYEE;
 SELECT EMP_NAME, SALARY, '원 입니다' AS "문장" FROM EMPLOYEE;
 
-- ===============================================================================

-- 5. DISTINCT : 조회 시 컬럼에 포함된 중복 값을 한번만 표기
 -- 규칙1. DISTINCT 구문은 SELECT 마다 단 한 번만 작성 가능
 -- 규칙2. DISTINCT 구문은 SELECT 가장 앞에 작성되어야 함
 SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE; -- 해당 테이블의 값들은 중복값이 많다
 SELECT DISTINCT DEPT_CODE, JOB_CODE FROM EMPLOYEE; 
 
-- ===============================================================================

-- 절 구분
 -- SELECT 절 : SELECT 컬럼명
 -- FROM 절 : FROM 테이블
 -- WHERE 절(조건절) : WHERE 컬럼명 연산자 값;
 -- ORDER BY 컬럼명 (별칭) (컬럼순서) (ASC/DESC) (NULLS) (FIRST/LAST)
  
 -- 해석 순서 : 1. FROM 테이블 어디서?
 --							2. WHERE 조건 어떻게?
 -- 						3. SELECT 어느 컬럼?
 --							4. ORDER BY 정렬 어떻게?
 
 -- EMPLOYEE 테이블에서 급여가 3백만원 초과인 사원의 사번, 이름, 급여, 부서코드 조회
 SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE FROM EMPLOYEE WHERE SALARY > 30000	00;

 -- 비교 연산자 : >, <, >=, <=, =, !, <>
 -- 대입 연산자 : :=
 
 -- EMPLOYEE 테이블에서 부서코드가 'D9'인 사원의 부서코드 및 직급코드 조회
 SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE WHERE DEPT_CODE = 'D9';

-- ===============================================================================

-- 논리연산자 (AND, OR, BETWEEN)

 -- EMPLOYEE 테이블에서 급여가 300 미만 또는 500 이상 사원의 사번, 이름, 급여, 전화번호 조회
 SELECT EMP_ID, EMP_NAME, SALARY, PHONE FROM EMPLOYEE WHERE SALARY < 3000000 OR SALARY >= 5000000;

 -- EMPLOYEE 테이블에서 급여가 300 이상이고 500 미만 사원의 사번, 이름, 급여, 전화번호 조회
 SELECT EMP_ID, EMP_NAME, SALARY, PHONE FROM EMPLOYEE WHERE SALARY >= 3000000 AND SALARY < 5000000;

 -- BETWEEN A AND B : A 이상 B 이하
  -- 300 이상, 600 이하
 SELECT EMP_ID, EMP_NAME, SALARY, PHONE FROM EMPLOYEE WHERE SALARY BETWEEN 3000000 AND 6000000;

  -- NOT 연산자도 사용 가능
 SELECT EMP_ID, EMP_NAME, SALARY, PHONE FROM EMPLOYEE WHERE SALARY NOT BETWEEN 3000000 AND 6000000;

	-- BETWEEN 은 날짜(DATE)에도 사용 가능
	 -- 입사일 1990-01-01 ~ 1999-12-31 직원의 이름, 입사일 조회
 SELECT EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE HIRE_DATE BETWEEN '1990-01-01' AND '1999-12-31';  
  
-- ===============================================================================

-- LIKE 연산자
 -- 비교하려는 값이 특정한 패턴을 만족시킬 때 조회하는 연산자
 -- [작성법] : WHERE 컬럼명 LIKE '패턴이 적용된 값'
  
  -- LIKE 패턴을 나타내는 문자
   -- 1) '%' : 포함
	  -- 'A%' : A로 시작하는 문자열
	  -- '%A' : A로 끝나는 문자열
	  -- '%A%' : A를 포함하는 문자열
 	 
   -- 2) '_' : 글자수
	  -- '____A' : A로 끝나는 5글자 문자열
		-- '__A__' : A가 3번째에 위치하는 5글자 문자열
		-- '_____' : 5글자 문자열

	-- EMPLOYEE 테이블에서 성이 '전'씨인 사원의 사번, 이름 조회
	SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE EMP_NAME LIKE '전%';

  -- EMPLOYEE 테이블에서 전화번호가 010으로 시작하지 않는 사원의 사번, 이름 , 전화번호 조회
	SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE WHERE PHONE NOT LIKE '010%';

	-- EMPLOYEE 테이블에서 EMAIL의 _ 앞에 글자가 세글자인 사원의 이름, 이메일 조회
  SELECT EMP_NAME, EMAIL FROM EMPLOYEE WHERE EMAIL LIKE '___^_%' ESCAPE '^';
   -- ESCAPE : ESCAPE 문자 뒤에 작성된 _, #, ^ 등은 일반문자로 탈출한다는 뜻

-- ===============================================================================

-- 연습문제 1.
 -- EMPLOYEE 테이블에서 이메일 '_' 앞이 4글자 이면서 부서코드가 D9 또는 D6 이고 입사일이 1990-01-01 ~ 2000-12-31 이며
 -- 급여가 270 이상인 사원의 사번, 이름, 이메일, 부서코드, 입사일, 급여 조회
 -- AND 가 OR 보다 우선순위가 높으며 () 사용 가능
 SELECT EMP_ID, EMP_NAME, EMAIL, DEPT_CODE, HIRE_DATE, SALARY
 FROM EMPLOYEE
 WHERE (EMAIL LIKE '____^_%' ESCAPE '^') AND (DEPT_CODE = 'D9' OR DEPT_CODE = 'D6') AND (HIRE_DATE BETWEEN '1990-01-01' AND '2000-12-31') AND (SALARY >= 2700000);

/* 연산자의 우선순위
 * 1. 산술 연산자(+,-,*,/)
 * 2. 연결 연산자 ( || ) (*JAVA 에서 OR과 같다)
 * 3. 비교 연산자 ( < > <= >= != <> )
 * 4. IS NULL / IS NOT NULL / LIKE / IN / NOT IN
 * 5. BETWEEN AND / NOT BETWEEN AND
 * 6. NOT (논리 연산자)
 * 7. AND
 * 8. OR
 * */

-- ===============================================================================

-- IN 연산자 : 비교하려는 값과 목록에 작성된 값 중 일치하는 것이 있으면 조회
 -- [작성법] : 
  -- WHERE 컬럼명 IN(값1, 값2, 값3 ....)
  -- OR 로 풀어 쓸 시 : WHERE (컬럼명 = '값1') OR (컬럼명 = '값2') OR (컬럼명 = '값3') ... 

 -- EMPLOYEE 테이블에서 부서코드가 D1, D6, D9 사원의 사번, 이름, 부서코드 조회
 SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE IN('D1', 'D6', 'D9');
 SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE NOT IN('D1', 'D6', 'D9');
  -- IN 또는 NOT IN 은 NULL 값을 제외한다.
 	-- NULL 을 포함하고 싶을 땐
  SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE NOT IN('D1', 'D6', 'D9') OR DEPT_CODE IS NULL;
 -- IS NULL : NULL 인 경우 조회
 -- IS NOT NULL : NULL 이 아닌 경우 조회
 
 -- EMPLOYEE 테이블에서 보너스가 있는 사원의 이름, 보너스 조회
 SELECT EMP_NAME, BONUS FROM EMPLOYEE WHERE BONUS IS NOT NULL;

-- ===============================================================================

-- ORDER BY 절
 -- SELECT 문의 조회 결과(RESULT SET)를 정렬할 때 사용
 -- SELECT 문 해석 시 가장 마지막에 처리됨

 -- EMPLOYEE 테이블에서 급여 오름차순으로 사번, 이름, 급여 조회
 SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY ASC; -- 오름차순(기본값)
 SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC; -- 내림차순 
  
 -- EMPLOYEE 테이블에서 급여 200 이상 사원의 사번, 이름, 급여 조회, 급여 내림차순 조회
 SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE WHERE SALARY >= 2000000 ORDER BY SALARY DESC;

 -- ORDER BY 절은 조회된 RESULT SET 컬럼명의 순서를 대신해서 쓸 수도 있다.
 SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE WHERE SALARY >= 2000000 ORDER BY 3 DESC; 

 -- 입사일 순서대로 이름, 입사일 조회 (별칭 사용)
  --> 해석순서가 ORDER BY 가 제일 마지막이기에 가능하다
 SELECT EMP_NAME "이름", HIRE_DATE "입사일" FROM EMPLOYEE ORDER BY "입사일" ASC; 

 -- 정렬 중첩 : 대분류 정렬 후 소분류 정렬
  -- 부서코드 오름차순 정렬 후 급여 내림차순 정렬
 SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE ORDER BY DEPT_CODE ASC, SALARY DESC;

