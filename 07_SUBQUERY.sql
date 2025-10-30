/*
	SUBQUERY 란? 
	(서브쿼리 = 내부쿼리)
	 - 하나의 SQL 문 안에 포함된 또 다른 SQL(SELECT) 문
	 - 메인쿼리( = 외부쿼리, 기존쿼리)를 위해 보조 역할을 하는 쿼리문	
	 - 메인쿼리가 SELECT 문일 때,
	 	 SELECT, FROM, WHERE, HAVING 절에서 사용 가능
   - 서브쿼리는 반드시 SELECT 문이어야 하지만 메인쿼리가 SELECT 일 필요는 없다
     UPDATE, INSERT 등의 메인쿼리에서 사용 가능
*/

-- =====================================================================

-- 서브쿼리 예시 1.
	-- 부서코드가 노옹철 사원과 같은 소속 직원의 이름, 부서코드 조회
	SELECT EMP_NAME, DEPT_CODE
	FROM EMPLOYEE
	WHERE DEPT_CODE = (
		SELECT DEPT_CODE
		FROM EMPLOYEE
		WHERE EMP_NAME = '노옹철');
	-- AND EMP_NAME != '노옹철';

	/* 1) 노옹철의 부서코드 조회 (서브쿼리)
	SELECT DEPT_CODE
	FROM EMPLOYEE
	WHERE EMP_NAME = '노옹철'; -- D9
	
	-- 2) 부서코드가 D9인 직원의 이름, 부서코드 조회 (메인쿼리)
	SELECT EMP_NAME, DEPT_CODE
	FROM EMPLOYEE
	WHERE DEPT_CODE = 'D9';
	
	
	-- 3) 부서코드가 노옹철 사원과 같은 소속 직원 조회
	--> 위의 2개 단계를 하나의 쿼리로!
	SELECT EMP_NAME, DEPT_CODE
	FROM EMPLOYEE
	WHERE DEPT_CODE = (SELECT DEPT_CODE
						FROM EMPLOYEE
						WHERE EMP_NAME = '노옹철'); */

-- 서브쿼리 예시 2.
 -- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직워의 사번, 이름, 직급코드, 급여 조회
 SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
 WHERE SALARY > (SELECT CEIL(AVG(SALARY)) FROM EMPLOYEE);
		
-- =====================================================================

/* 서브쿼리 유형
 
- 단일행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때
  
- 다중행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때
  
- 다중열 서브쿼리 : 서브쿼리의 SELECT 절에 나열된 항목수가 여러개일 때
  
- 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때
  
- 상(호연)관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인쿼리가 비교 연산할 때
  											메인쿼리 테이블의 값이 변경되면 서브쿼리의 결과값도 바뀌는 서브쿼리
  
- 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 하나인 서브쿼리
  
** 서브쿼리 유형에 따라 서브쿼리 앞에 붙는 연산자가 다름 ** 
  
*/	

-- =====================================================================

-- 1. 단일행 서브쿼리 (SINGLE ROW SUBQUERY)
 -- 서브쿼리의 조회 결과 값의 개수가 1인 서브쿼리
 -- 단일행 서브쿼리 앞에는 비교 연산자 사용
 -- <, >, <=, >=, =, <> / != / ^=

	-- 전 직원의 급여 평균보다 초과하여 급여를 받는 직원의 이름, 직급명, 부서명, 급여를 직급 순으로 정렬 조회
	SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY
	FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
	LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	WHERE SALARY > (
		SELECT CEIL(AVG(SALARY)) -- 서브쿼리 조회 결과 단일 행(열도 단일 열이다) 
		FROM EMPLOYEE)
	ORDER BY JOB_CODE ASC;
	-- SELECT 절에 명시되지 않은 컬럼이라도 FROM, JOIN 으로 인해 테이블 상에 존재하는 컬럼이라면 ORDER BY 절에 사용 가능

	-- 가장 적은 급여를 받는 직원의 사번, 이름, 직급명, 부서코드, 급여, 입사일 조회
	SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_CODE, SALARY, HIRE_DATE
	FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
	WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);
		
	-- 노옹철 사원의 급여보다 초과하여 받는 직원의 사번, 이름, 부서명, 직급명, 급여 조회
	SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY
	FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	WHERE SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '노옹철');
		
	-- 부서별(부서가 없는 사람 포함) 급여의 합계 중 가장 큰 부서의 부서명, 급여 합계 조회	
	SELECT DEPT_TITLE, SUM(SALARY)
	FROM EMPLOYEE
	LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	GROUP BY DEPT_TITLE -- 여기선 메인 쿼리에서도 GROUP BY 필수
	HAVING SUM(SALARY) = (
		SELECT MAX(SUM(SALARY)) 
		FROM EMPLOYEE
		GROUP BY DEPT_CODE);

-- =====================================================================

-- 2. 다중행 서브쿼리 (MULTI ROW SUBQUERY)
 -- 서브쿼리의 조회 결과 값의 개수가 여러 행일 때

/* 
 
 다중행 서브쿼리 앞에는 일반 비교연산자 사용 X
  
 - 'IN' / 'NOT IN' : 여러 개의 결과값 중에서 한 개라도 일치하는 값이 있다 / 없다 의 의미 (가장 많이 사용)
  
 - '> ANY', '< ANY' : 여러개의 결과값 중에서 한 개라도 큰 / 작은 경우
 					 					  가장 작은 값 보다 큰가? / 가장 큰 값 보다 작은가?
  
 - '> ALL', '< ALL' : 여러개의 결과값의 모든 값 보다 큰 / 작은 경우
  										가장 큰 값 보다 큰가? / 가장 작은 값 보다 작은가?
  
 - 'EXISTS' / 'NOT EXISTS' : 값이 존재하는가? / 존재하지 않는가?
 
 */	
		
	-- 부서별 최고 급여를 받는 직원의 이름, 직급, 부서, 급여를 부서 순으로 정렬하여 조회
	SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY
	FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	WHERE SALARY IN (
		SELECT MAX(SALARY)
		FROM EMPLOYEE
		GROUP BY DEPT_CODE)
	ORDER BY DEPT_CODE;

	-- 사수에 해당하는 직원 조회 사번, 이름, 부서명, 직급명 조회하고, 구분(사수/사원)
		
		-- 방법1)
		SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사수'
		FROM EMPLOYEE
		JOIN JOB USING(JOB_CODE)
		LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
		WHERE EMP_ID IN(SELECT DISTINCT MANAGER_ID FROM EMPLOYEE WHERE MANAGER_ID IS NOT NULL)
		 	-- 서브쿼리 : 사수가 있는 사람만 조회하고 중복 제거
			-- 사번이 서브쿼리(사수)에 있는 번호 중 하나와 일치하면 역할이 사수일 것임
	
		UNION -- 집합연산자 사용 
	
		SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '사원'
		FROM EMPLOYEE
		JOIN JOB USING(JOB_CODE)
		LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
		WHERE EMP_ID NOT IN(SELECT DISTINCT MANAGER_ID FROM EMPLOYEE WHERE MANAGER_ID IS NOT NULL); 
		
		-- 방법2)
		-- 2. 선택 함수 사용 
		--> DECODE(컬럼명, 값1, 1인경우, 값2, 2인경우..., 일치하지않는경우);
		--> CASE WHEN 조건1 THEN 값1
		--		WHEN 조건2 THENT 값2
		-- 		ELSE 값3
		-- 		END 별칭
		SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME,
			CASE WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID FROM EMPLOYEE WHERE MANAGER_ID IS NOT NULL)
			THEN '사수' 
			ELSE '사원'
			END AS "구분"
		FROM EMPLOYEE
		JOIN JOB USING(JOB_CODE)
		LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

	-- 대리 직급 직원들 중 과장 직급 최소 급여보다 많이 받는 직원의 사번, 이름, 직급명, 급여 조회
		
		-- 방법 1)
		SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
		FROM EMPLOYEE
		JOIN JOB USING (JOB_CODE)
		WHERE SALARY > ANY (
			SELECT SALARY
			FROM EMPLOYEE
			JOIN JOB USING (JOB_CODE)
			WHERE JOB_NAME = '과장')
		AND JOB_NAME = '대리';

		-- 방법 2)
		SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
		FROM EMPLOYEE
		JOIN JOB USING(JOB_CODE)
		WHERE JOB_NAME = '대리'
		AND SALARY > (SELECT MIN(SALARY)
						FROM EMPLOYEE
						JOIN JOB USING(JOB_CODE)
						WHERE JOB_NAME = '과장');

	-- 차장 직급 급여 중 가장 큰 값보다 많이 받는 과장 직급 직원의 사번, 이름, 직급, 급여 조회
	SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
	FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
	WHERE SALARY > ALL (
		SELECT SALARY 
		FROM EMPLOYEE
		JOIN JOB USING (JOB_CODE)
		WHERE JOB_NAME = '차장')
	AND JOB_NAME = '과장';

-- =====================================================================

-- 서브쿼리 중첩 사용
	
	-- 1) LOCATION 테이블에서 NATIONAL_CODE 가 KO 인 경우의 LOCAL_CODE 와
	-- 2) DEPARTMENT 테이블의 LOCATION_ID 와 동일한 DEPT_ID 가 EMPLOYEE 테이블의 DEPT_CODE 와 동일한 사원의 이름, 부서코드 조회
	
	-- 순서 1 : LOCATION 테이블에서 NATIONAL_CODE 가 KO 인 경우의 LOCAL_CODE 조회
	SELECT LOCAL_CODE FROM LOCATION WHERE NATIONAL_CODE = 'KO'; -- L1
	
	-- 순서 2 : 순서 1의 결과와 '동일'한 LOCATION_ID 와 가지고 있는 DEPT_ID 조회
	SELECT DEPT_ID FROM DEPARTMENT WHERE LOCATION_ID = (
		SELECT LOCAL_CODE FROM LOCATION WHERE NATIONAL_CODE = 'KO'); 

	-- 순서 3 : 순서 2의 결과에 '포함'된 DEPT_CODE 를 가진 사원의 이름, 부서코드 조회
		SELECT EMP_NAME, DEPT_CODE
		FROM EMPLOYEE
		WHERE DEPT_CODE IN (
			SELECT DEPT_ID FROM DEPARTMENT WHERE LOCATION_ID = (
				SELECT LOCAL_CODE FROM LOCATION WHERE NATIONAL_CODE = 'KO')); 

-- =====================================================================

-- 3. (단일행) 다중열 서브쿼리
 -- 서브쿼리 SEELCT 절에 나열된 컬럼수가 여러 개일 때

	-- 퇴사한 여직원과 같은 부서, 직급에 해당하는 사원의 이름, 직급코드, 부서코드, 입사일 조회
		
		-- 방법 1) 단일행 서브쿼리 2개 사용
		SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
		FROM EMPLOYEE
		WHERE DEPT_CODE = (SELECT DEPT_CODE
 											 FROM EMPLOYEE
											 WHERE ENT_YN = 'Y' AND SUBSTR(EMP_NO, 8, 1) = '2')
		AND JOB_CODE = (SELECT JOB_CODE
 										FROM EMPLOYEE
										WHERE ENT_YN = 'Y' AND SUBSTR(EMP_NO, 8, 1) = '2');
	
		-- 방법 2) 다중열 서브쿼리 사용
		 -- WHERE 절에 작성된 컬럼 순서에 맞게 서브쿼리의 조회된 컬럼과 비교하여 일치하는 행만 조회
		 -- 컬럼 순서가 중요하다!
		SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
		FROM EMPLOYEE
		WHERE (DEPT_CODE, JOB_CODE) = (
			SELECT DEPT_CODE, JOB_CODE
			FROM EMPLOYEE
			WHERE ENT_YN = 'Y' AND SUBSTR(EMP_NO, 8, 1) = '2');
		
	-- 연습문제
	
	-- A. 노옹철 사원과 같은 부서, 같은 직급인 사원의 사번, 이름, 부서코드, 직급코드, 부서명, 직급명 조회 (노옹철 제외)
	SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
	FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
	LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	WHERE (DEPT_CODE, JOB_CODE) = (
		SELECT DEPT_CODE, JOB_CODE
		FROM EMPLOYEE
		WHERE EMP_NAME = '노옹철')
	AND EMP_NAME != '노옹철';
	
	-- B. 2000년에 입사한 사원의 부서와 직급이 같은 사원의 사번, 이름, 부서코드, 직급코드, 입사일 조회
	SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
	FROM EMPLOYEE
	WHERE (DEPT_CODE, JOB_CODE) = (
		SELECT DEPT_CODE, JOB_CODE 
		FROM EMPLOYEE
		WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000);

	-- C. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원의 사번, 이름, 부서코드, 사수번호, 주민번호, 입사일 조회
	SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
	FROM EMPLOYEE
	WHERE (DEPT_CODE, MANAGER_ID) = (
		SELECT DEPT_CODE, MANAGER_ID
		FROM EMPLOYEE
		WHERE SUBSTR(EMP_NO, 1, 2) = 77 -- WHERE EMP_NO LIKE '77%'
		AND SUBSTR(EMP_NO, 8, 1) = 2);

-- =====================================================================

-- 4. 다중행, 다중열
 -- 서브쿼리 조회 결과 행 수와 열 수가 여러 개일 때

	-- 본인이 소속된 직급의 평균 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여 조회
	SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
	FROM EMPLOYEE
	WHERE (JOB_CODE, SALARY) IN (
		SELECT JOB_CODE, TRUNC(AVG(SALARY), -4) -- 만원 단위 절삭 
		FROM EMPLOYEE
		GROUP BY JOB_CODE);

-- =====================================================================

-- 5. 상[호연]관 서브쿼리                        
 -- 상관 쿼리는 메인쿼리가 사용하는 테이블값을 서브쿼리가 이용해서 결과를 만듦
 -- 메인쿼리의 테이블값이 변경되면 서브쿼리의 결과값도 바뀌게 되는 구조

 -- 상관쿼리는 먼저 메인쿼리 한 행을 조회하고 해당 행이 서브쿼리의 조건을 충족하는지 확인
 -- 확인된다면 그 후 SELECT 진행

 -- ** 해석순서가 기존 서브쿼리와 다르게
 -- 메인쿼리 1행 -> 1행에 대한 서브쿼리 수행
 -- 메인쿼리 2행 -> 2행에 대한 서브쿼리 수행
 -- ...
 -- 메인쿼리의 행의 수 만큼 서브쿼리가 생성되어 진행됨

 -- * 상관 서브쿼리는 행마다 비교/검증이 필요할 때 사용
	-- > 속도가 느리다

	-- Q. 직급별 급여 평균보다 급여를 많이 받는 직원의 이름, 직급코드, 급여 조회	
	SELECT EMP_NAME, JOB_CODE, SALARY 
	FROM EMPLOYEE MAIN
	WHERE SALARY > (
		SELECT AVG(SALARY)
		FROM EMPLOYEE SUB
		WHERE MAIN.JOB_CODE = SUB.JOB_CODE);

	-- Q. 부서별 입사일이 가장 빠른 사원의 사번, 이름, 부서코드, 부서명(NULL 이면 '소속 없음'), 직급명, 입사일 조회
	 -- 입사일 빠른 순으로 정렬, 퇴사한 직원 제외
	SELECT EMP_ID, EMP_NAME, DEPT_CODE, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE
	FROM EMPLOYEE MAIN
	JOIN JOB USING(JOB_CODE)
	LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
	WHERE HIRE_DATE = (
		SELECT MIN(HIRE_DATE)
		FROM EMPLOYEE SUB
		WHERE ENT_YN = 'N'
		AND MAIN.DEPT_CODE = SUB.DEPT_CODE)
	ORDER BY HIRE_DATE ASC;

-- =======================================================================
	
-- 6. 스칼라 
 -- SELECT 절에 사용되는 서브쿼리로 결과를 1행만 반환
 -- SQL 에서 단일 값을 '스칼라' 라고 정의함
 -- 즉, SELECT 절에 작성되는 단일행, 단일열 서브쿼리를 스칼라 서브쿼리라고 함

	-- 모든 직원의 이름, 급여, 전체 사원 중 가장 높은 급여와의 차 조회
	SELECT EMP_NAME, JOB_CODE, SALARY, (SELECT MAX(SALARY) FROM EMPLOYEE) - SALARY "급여 차"
	FROM EMPLOYEE;

	-- 모든 사원의 직급, 이름, 직급코드, 급여 각 직원들이 속한 직급의 급여 평균
	 -- 스칼라 + 상관 쿼리
	SELECT EMP_NAME, JOB_CODE, SALARY, (
		SELECT CEIL(AVG(SALARY)) 
		FROM EMPLOYEE SUB 
		WHERE MAIN.JOB_CODE = SUB.JOB_CODE) "직급 평균"
	FROM EMPLOYEE MAIN
	ORDER BY JOB_CODE;

-- =======================================================================

-- 7. 인라인 뷰
 -- FROM 절에서 서브쿼리를 사용하는 경우
 -- 서브쿼리가 만든 결과집합(RESULT SET)을 테이블 대신 사용

	-- Q.
	SELECT EMP_NAME 이름, DEPT_TITLE 부서
	FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

	-- 부서가 기술지원부인 모든 값 조회
	SELECT *
	FROM (SELECT EMP_NAME 이름, DEPT_TITLE 부서
				FROM EMPLOYEE
				JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID))
	WHERE 부서 = '기술지원부';

	-- 인라인뷰 활용한 TOP-N 분석
	
	-- Q1. 전 직원 중 급여가 높은 상위 5명의 순위, 이름, 급여 조회

		-- * ROWNUM 컬럼 : 행번호를 나타내는 가상 컬럼
		-- SELECT, WHERE, ORDER BY 절 사용 가능
	
		SELECT ROWNUM, EMP_NAME, SALARY
		FROM EMPLOYEE
		WHERE ROWNUM <= 5
		ORDER BY SALARY DESC;
	  -- 해석 순서로 인해 상위 5명이 아닌 조회순서 상 5명이 조회될 뿐임
		-- 따라서 다른 코드 필요
		-- > 인라인 뷰 이용
	
		-- 1) 이름, 급여를 급여 내림차순으로 조회한 결과를 인라인 뷰에 사용
			-- > FROM 절에 작성되기 때문에 해석 1순위
		SELECT SELECT EMP_NAME, SALARY
		FROM EMPLOYEE
		ORDER BY SALARY DESC;
		
		-- 2) 메인쿼리 조회 시 인라인뷰 이용하여 급여 상위 5명까지 조회
		SELECT ROWNUM, EMP_NAME, SALARY
		FROM (SELECT EMP_NAME, SALARY
					FROM EMPLOYEE
					ORDER BY SALARY DESC)
		WHERE ROWNUM <= 5;

	-- Q2. 급여 평균 3위 안에 드는 부서의 부서코드, 부서명, 평균급여 조회
 	 -- > 인라인뷰 + GROUP BY
	SELECT DEPT_CODE, DEPT_TITLE, 평균급여
	FROM(SELECT DEPT_CODE, DEPT_TITLE, CEIL(AVG(SALARY)) 평균급여
			FROM EMPLOYEE
			LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
			GROUP BY DEPT_CODE, DEPT_TITLE -- GROUP BY 사용규칙 : 그룹함수에 사용된 컬럼명 제외하고 모든 컬럼명 GROUP BY 에 작성
			ORDER BY 평균급여 DESC)
		WHERE ROWNUM <= 3;

-- =======================================================================

-- 8. WITH
 -- 서브쿼리에 이름을 붙여주고 사용 시 이름을 사용하게 함
 -- 인라인뷰로 사용될 서브쿼리에 주로 사용
 -- 실행속도 빨라짐

	-- 전 직원의 급여 순위
	-- 순위, 이름, 급여 조회 (10위까지)

	WITH TOP_SAL AS (SELECT EMP_NAME, SALARY
	FROM EMPLOYEE
	ORDER BY SALARY DESC)

	SELECT ROWNUM, EMP_NAME, SALARY
	FROM TOP_SAL
	WHERE ROWNUM <= 10;
		
-- =======================================================================

-- 9. RANK() OVER / DENSE_RANK() OVER
 
	-- RANK() OVER : 동일한 순위 이후의 등수를 동일한 인원 수만큼 건너뛰고 순위 계산
	 -- EX) 공동 1위 2명 시 다음 순위는 3위

	-- 사원별 급여 순위 조회
	SELECT RANK() OVER(ORDER BY SALARY DESC) "순위", EMP_NAME, SALARY
	FROM EMPLOYEE;

	-- DENSE_RANK() OVER : 건너뛰기 안 함
	 -- EX) 공동 1위 2명 시 다음 순위는 2위
	SELECT DENSE_RANK() OVER(ORDER BY SALARY DESC) "순위", EMP_NAME, SALARY
	FROM EMPLOYEE;


-- ====================================================================================

-- 서브쿼리 실습문제 --

-- 1. 전지연 사원이 속해있는 부서원들을 조회하시오 (단, 전지연은 제외)
-- 사번, 사원명, 전화번호, 고용일, 부서명
SELECT EMP_ID, EMP_NAME, PHONE, TO_CHAR(HIRE_DATE, 'RR/MM/DD') "고용일", DEPT_TITLE
FROM EMPLOYEE
LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE IN (
	SELECT DEPT_TITLE
	FROM EMPLOYEE
	LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	WHERE EMP_NAME = '전지연')
AND EMP_NAME != '전지연';

/* 답안
SELECT EMP_ID, EMP_NAME, PHONE, TO_CHAR(HIRE_DATE, 'RR/MM/DD'), DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (
	SELECT DEPT_CODE 
	FROM EMPLOYEE
	WHERE EMP_NAME = '전지연')
AND EMP_NAME != '전지연';
*/
	
-- 2. 고용일이 2000년도 이후인 사원들 중 급여가 가장 높은 사원의
-- 사번, 사원명, 전화번호, 급여, 직급명을 조회하시오.
SELECT EMP_ID, EMP_NAME, PHONE, SALARY, JOB_NAME, HIRE_DATE
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE SALARY > ALL (
	SELECT SALARY
	FROM EMPLOYEE
	WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2000);

/*
SELECT EMP_ID, EMP_NAME, PHONE, SALARY, JOB_NAME, HIRE_DATE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY = 
( SELECT MAX(SALARY) FROM EMPLOYEE
 HIRE_DATE >= TO_DATE('2001-01-01', 'YYYY-MM-DD'	) );
*/

-- 3. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오. (단, 노옹철 사원은 제외)
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE (DEPT_CODE, JOB_CODE) = (
	SELECT DEPT_CODE, JOB_CODE
	FROM EMPLOYEE
	WHERE EMP_NAME = '노옹철')
AND EMP_NAME != '노옹철';
	
-- 4. 2000년에 입사한 사원과 부서와 직급이 같은 사원을 조회하시오
-- 사번, 이름, 부서코드, 직급코드, 고용일
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (
	SELECT DEPT_CODE, JOB_CODE 
	FROM EMPLOYEE
	WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000);

-- 5. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오
-- 사번, 이름, 부서코드, 사수번호, 주민번호, 고용일
SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) IN (
	SELECT DEPT_CODE, MANAGER_ID 
	FROM EMPLOYEE
	WHERE SUBSTR(EMP_NO, 1, 2) = 77
	AND SUBSTR(EMP_NO, 8, 1) = 2);

-- 6. 부서별 입사일이 가장 빠른 사원의
-- 사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
-- 입사일이 빠른 순으로 조회하시오
-- 단, 퇴사한 직원은 제외하고 조회..
	
	-- 1) 다중행 서브쿼리 사용(GROUP BY)
	-- 서브쿼리(부서별 가장빠른 입사일, 퇴사한 사람은 제외)
	SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '소속없음'),
	JOB_NAME, HIRE_DATE
	FROM EMPLOYEE
	JOIN JOB USING(JOB_CODE)
	LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
	WHERE HIRE_DATE IN (
		SELECT MIN(HIRE_DATE)
		FROM EMPLOYEE
		WHERE ENT_YN != 'Y'
		GROUP BY DEPT_CODE)
	ORDER BY HIRE_DATE;

	-- 2) 상관 서브쿼리
	SELECT EMP_ID, DEPT_CODE, EMP_NAME, NVL(DEPT_TITLE, '소속없음'),
	JOB_NAME, HIRE_DATE
	FROM EMPLOYEE MAIN
	JOIN JOB USING(JOB_CODE)
	LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
	WHERE HIRE_DATE = (
		SELECT MIN(HIRE_DATE)
		FROM EMPLOYEE SUB
		WHERE ENT_YN != 'Y'
		AND MAIN.DEPT_CODE = SUB.DEPT_CODE
		OR (MAIN.DEPT_CODE IS NULL AND SUB.DEPT_CODE IS NULL))
	ORDER BY HIRE_DATE;


-- 7. 직급별 나이가 가장 어린 직원의
-- 사번, 이름, 직급명, 나이, 보너스 포함 연봉을 조회하고
-- 나이순으로 내림차순 정렬하세요
-- 단 연봉은 \124,800,000 으로 출력되게 하세요. (\ : 원 단위 기호)


-- 다중행 서브쿼리
-- 서브쿼리 (GROUP BY) : 직급별 가장 어린 나이
SELECT MAX(EMP_NO) FROM EMPLOYEE
GROUP BY JOB_CODE;


-- 메인쿼리
SELECT EMP_ID, EMP_NAME, JOB_NAME,
FLOOR(MONTHS_BETWEEN(SYSDATE, 
TO_DATE(SUBSTR(EMP_NO, 1, 6), 'RRMMDD')) / 12) "나이",
TO_CHAR(SALARY * ( 1 + NVL(BONUS, 0) ) * 12, 
'L999,999,999') "보너스 포함 연봉"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE EMP_NO IN (SELECT MAX(EMP_NO) FROM EMPLOYEE
GROUP BY JOB_CODE)
ORDER BY "나이" DESC;




-- 나이 구하기
SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, 
TO_DATE(SUBSTR(EMP_NO, 1, 6), 'RRMMDD')) / 12) "나이"
FROM EMPLOYEE;

-- 보너스 포함 연봉 구하기
SELECT TO_CHAR(SALARY * ( 1 + NVL(BONUS, 0) ) * 12, 
'L999,999,999') "보너스 포함 연봉"
FROM EMPLOYEE;

		