/* SELECT문 해석 순서
 *
 * 5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
 * 1 : FROM 테이블명
 * 2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
 * 3 : GROUP BY 그룹을 묶을 컬럼명
 * 4 : HAVING 그룹함수식 비교연산자 비교값
 * 6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식(ASC/DESC) [NULLS FIRST | LAST];
 * 
 * */

--------------------------------------------------------------------------------

-- * GROUP BY절 : 같은 값들이 여러개 기록된 컬럼을 가지고 같은 값들을 하나의 그룹으로 묶음


-- GROUP BY 컬럼명 | 함수식, ..

-- 여러개의 값을 묶어서 하나로 처리할 목적으로 사용함
-- 그룹으로 묶은 값에 대해서 SELECT절에서 그룹함수를 사용함

-- 그룹함수는 단 한개의 결과값만 산출하기 때문에 그룹이 여러개일 경우 오류 발생
-- 여러 개의 결과값을 산출하기 위해 그룹함수가 적용된 그룹의 기준을 ORDER BY절에 기술하여 사용

-- EMPLOYEE 테이블에서 부서코드, 부서별 급여 합 조회

-- 1) 부서코드만 조회
SELECT DEPT_CODE FROM EMPLOYEE;

-- 2) 급여 합 조회
SELECT SUM(SALARY) FROM EMPLOYEE;

SELECT DEPT_CODE, SUM(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE ;
--> DEPT_CODE 컬럼을 그룹으로 묶어, 그 그룹의 급여 합계를 구함

 -- EMPLOYEE 테이블에서 직급코드가 같은 사람의 직급 코드, 급여, 평균, 인원 수를 직급코드 오름차순으로 조회
 SELECT JOB_CODE, ROUND(AVG(SALARY)), COUNT(*) 
 FROM EMPLOYEE 
 GROUP BY JOB_CODE
 ORDER BY JOB_CODE ASC;

 -- EMPLOYEE 테이블에서 성별(남/여)과 각 성별 별 인원수, 급여 합을 인원 수 오름차순으로 조회

 SELECT DECODE(SUBSTR(EMP_NO, 8 ,1), 1, '남', 2, '여') "성별",
				COUNT(*) "인원 수",
				SUM(SALARY) "급여 합"
 FROM EMPLOYEE
 GROUP BY DECODE(SUBSTR(EMP_NO, 8 ,1), 1, '남', 2, '여')  -- 별칭 사용 불가, SELECT 절 연산 전이기 때문에
 ORDER BY "인원 수"; -- SELECT 절 연산이 완료된 후이기 때문에 별칭 사용 가능
 
 -- WHERE 절과 GROUP BY 절 혼합 사용
  --> WHERE 절은 각 컬럼값에 대한 조건
  --> HAVING 절은 그룹에 대한 조건
 
 -- 부서 코드가 D5, D6 인 부서의 부서코드, 평균급여, 인원 수 조회
 SELECT DEPT_CODE, ROUND(AVG(SALARY)), COUNT(*)
 FROM EMPLOYEE
 WHERE DEPT_CODE IN ('D5', 'D6')
 GROUP BY DEPT_CODE; 

 -- EMPLOYEE 테이블에서 2000년도 이후 입사자들의 직급별 급여 합 조회
 SELECT JOB_CODE, SUM(SALARY)
 FROM EMPLOYEE
 WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2000
 GROUP BY JOB_CODE;

-- =================================================================

-- * 여러 컬럼을 묶어서 그룹으로 지정 가능 --> 그룹 내 그룹이 가능

 -- EMPLOYEE 테이블에서 부서별로 같은 직급인 사원의 인원수 조회
 -- 부서코드 오름차순, 직급코드 내림차순 정렬
 -- 부서코드, 직급코드, 인원수
 SELECT DEPT_CODE, JOB_CODE, COUNT(*)
 FROM EMPLOYEE
 GROUP BY DEPT_CODE, JOB_CODE -- 첫번째로 DEPT_CODE 로 그룹화, 나눠진 그룹 내에서 JOB_CODE 로 재그룹화
 ORDER BY DEPT_CODE ASC, JOB_CODE DESC;

 -- * GROUP BY 사용 시,
  -- SELECT 절에 명시하여 조회하려는 컬럼 중 그룹함수가 적용되지 않은 컬럼은 모두 GROUP BY 절에 사용해야 한다.

-- =================================================================

-- HAVING 절
 -- 그룹함수로 구해 올 그룹에 대한 조건을 설정할 때 사용

 -- EMPLOYEE 테이블에서 부서별 평균 급여가 300 이상 부서의 부서코드, 평균급여 조회, 부서코드 오름차순
 SELECT DEPT_CODE, ROUND(AVG(SALARY)), COUNT(*)
 FROM EMPLOYEE
 GROUP BY DEPT_CODE 
 HAVING AVG(SALARY) >= 3000000 -- 이 때 HAVING 절은 '부서별 평균 급여'이다. WHERE 절은 EMPLOYEE 전체를 대상으로 하기 때문에 쓰지 않는다.
 ORDER BY DEPT_CODE; 
 
 -- EMPLOYEE 테이블에서 직급별 인원수가 5명 이하인 직급의 직급코드, 인원수 조회, 직급코드 오름차순
 SELECT JOB_CODE, COUNT(*)
 FROM EMPLOYEE
 GROUP BY JOB_CODE
 HAVING COUNT(*) <= 5
 ORDER BY JOB_CODE ASC; -- ORDER BY 1; 역시 가능하다.
 
 -- * HAVING 절에는 반드시 그룹함수가 있다.
 
-- =================================================================
 
-- 집계함수
 -- ROLLUP, CUBE
 -- GROUP BY 절에서 이용할 수 있다.
 -- 그룹 별 산출 결과값의 집계를 계산하는 함수
 -- 그룹별로 중간 집계 결과를 추가
 
 -- ROLLUP : GROUP BY 절에서 가장 먼저 작성된 컬럼의 집계함수를 처리하는 함수
 SELECT DEPT_CODE, JOB_CODE, COUNT(*)
 FROM EMPLOYEE
 GROUP BY ROLLUP (DEPT_CODE, JOB_CODE)
 ORDER BY DEPT_CODE ASC;
  -- > 설명 : ROLLUP 을 사용하기 전과 비교하여, 각각의 부서코드 밑에 집계된 값이 나온다.
	--					마지막 줄은 전체 집계 결과

 -- CUBE : GROUP BY 절에 작성된 모든 컬럼의 중간집계를 처리하는 함수
 SELECT DEPT_CODE, JOB_CODE, COUNT(*)
 FROM EMPLOYEE
 GROUP BY CUBE (DEPT_CODE, JOB_CODE)
 ORDER BY DEPT_CODE ASC;
  --> 설명 : ROLLUP 과 비교하여, JOB_CODE에 대한 중간집계 결과가 추가되었다.


-- =================================================================



/* SET OPERATOR (집합 연산자) 
	-- 여러 SELECT의 결과(RESULT SET)를 하나의 결과로 만드는 연산자

	- UNION (합집합) : 두 SELECT 결과를 하나로 합침. 단, 중복은 한 번만 작성

	- INTERSECT (교집합) : 두 SELECT 결과 중 중복되는 부분만 조회

	- UNION ALL : UNION + INTERSECT > 합집합에서 중복 부분 제거 X
							
	- MINUS (차집합) : A에서 A,B 교집합 부분을 제거하고 조회
*/

 -- 1) EMPLOYEE 테이블에서 부서코드가 'D5' 인 사원의 사번, 이름, 부서코드, 급여 조회 
 SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5';

 -- 2) EMPLOYEE 테이블에서 급여가 300 초과 사원의 사번, 이름, 부서코드, 급여 조회
 SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000;

 -- 위 2개의 쿼리를 하나로 합치기
  -- A) UNION
  SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
  UNION
  SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000;
   -- > 중복된 데이터는 하나로 처리(심봉선, 대북혼)

	-- B) INTERSECT
  SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
  INTERSECT
  SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000;
	 -- > 중복된 데이터만 추출

  -- C) UNION ALL
  SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
  UNION ALL
  SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000;
   -- > 중복된 데이터 구분없이 전부 출력

  -- D) MINUS
  SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
  MINUS
  SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY > 3000000;
   -- > 위쪽 쿼리에서 아래쪽 쿼리에서 겹치는 부분을 제거

-- * 집합연산자 사용 시
 -- SELECT 문의 조회하는 컬럼 타입, 개수 모두 동일해야 한다. > 다를 시 에러 발생
  -- ORA-01789: 질의 블록은 부정확한 수의 결과 열을 가지고 있습니다.
  -- ORA-01790: 대응하는 식과 같은 데이터 유형이어야 합니다
 -- 다만, 서로 다른 테이블일지라도 컬럼 타입, 개수만 일치하면 집합연산자 사용 가능하다.
	-- EX)
		 SELECT EMP_ID, EMP_NAME FROM EMPLOYEE
		 UNION
		 SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;