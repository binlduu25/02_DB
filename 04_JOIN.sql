/*
[JOIN 용어 정리]
  오라클                                   SQL : 1999표준(ANSI)
----------------------------------------------------------------------------------------------------------------
등가 조인                               내부 조인(INNER JOIN), JOIN USING / ON
                                  + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
----------------------------------------------------------------------------------------------------------------
포괄 조인                           왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                                + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
----------------------------------------------------------------------------------------------------------------
자체 조인, 비등가 조인                             JOIN ON
----------------------------------------------------------------------------------------------------------------
카테시안(카티션) 곱                        교차 조인(CROSS JOIN)
CARTESIAN PRODUCT


- 미국 국립 표준 협회(American National Standards Institute, ANSI) 미국의 산업 표준을 제정하는 민간단체.
- 국제표준화기구 ISO에 가입되어 있음.
*/

-- =============================================================================================================

-- JOIN
 -- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용.
 -- 수행 결과는 하나의 Result Set으로 나옴.

 -- (참고) JOIN은 서로 다른 테이블의 행을 하나씩 이어 붙이기 때문에 시간이 오래 걸리는 단점


/*
 - 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.

 - 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어 원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서
   데이터를 읽어와야 되는 경우가 많다. 이 때, 테이블간 관계를 맺기 위한 "연결고리" 역할이 필요한데, 
   두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가 됨.  
*/

-- =============================================================================================================

 -- 1. 내부 조인 (INNER JOIN) [ANSI] = 등가 조인 (EQUAL JOIN) [ORACLE]
  -- > 연결되는 컬럼의 값이 일치하는 행들만 조인
	-- > 일치하는 값이 없는 행은 조인에서 '제외'됨.

	-- 사번, 이름, 부서코드, 부서명 조회
  SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE;
  SELECT DEPT_TITLE FROM DEPARTMENT;

  -- 위 2개의 SELECT 문을 하나로 쓰고자 할 때(ANSI, ON)
  SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE 
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
 
  -- 작성법
	 -- ANSI 구문과 ORACLE 구문으로 나뉘고, ANSI 에서도 USING 과 ON 을 쓰는 방법으로 나뉜다.	
    
	 -- 1) 연결에 사용할 두 컬럼명이 다른 경우
	   -- ANSI 구문에서 ON 을 쓴다. 위 45~47번째 줄에서 사용한 것이 ANSI 와 ON 을 사용한 경우	
	 
		 -- DEPARTMENT 테이블, LOCATION 테이블 참조하여 부서명, 지역명 조회
		  -- 연결고리 
			-- DEPARATMENT : LOCATION_ID
			-- LOCATION : LOCAL_CODE
		  SELECT * FROM DEPARTMENT;
		  SELECT * FROM LOCATION;
		 
	  	-- ANSI 방식 (ON)
	 	  SELECT DEPT_TITLE, LOCAL_NAME 
	 	  FROM DEPARTMENT
	 	  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

			-- ORACLE 을 이용한 등가 조인 WHERE 절 활용
	 		SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
	 		FROM EMPLOYEE, DEPARTMENT
			WHERE DEPT_CODE = DEPT_ID;
		
	 -- 2) 연결에 사용할 두 컬럼명이 같은 경우
	  
	  -- EMPLOYEE, JOB 테이블 참조하여 사번, 이름, 직급코드, 직급명 조회
		 -- ANSI (USING)
		 SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME 
		 FROM EMPLOYEE
		 JOIN JOB USING(JOB_CODE);
		 
		 -- ORACLE 방식 (별칭을 활용해도 되고 컬럼명 자체를 활용해도 가능)
		 SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
		 FROM EMPLOYEE E, JOB J
		 WHERE E.JOB_CODE = J.JOB_CODE;

		 SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
		 FROM EMPLOYEE, JOB
		 WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;
	 
	 -- 3) 내부 JOIN 의 중요 특징 : 일치하는 값이 없으면 '제외'		
		-- > 일치하지 않는 값도 포함시키기 위해서는 외부 조인 이용

-- ===========================================================================================

 -- 2. 외부 조인(OUTER JOIN)
  -- 두 테이블의 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함시킴
  -- 반드시 OUTER JOIN 을 명시하여야 한다

 	SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE 
  FROM EMPLOYEE
  /*INNER*/ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- < INNER 가 생략된 상태이며 내부 조인은 INNER 를 생략 가능하다.

  -- LEFT, RIGHT, FULL
   -- 3가지 모두 OUTER JOIN 에서만 사용할 수 있기에 [OUTER] 는 생략이 가능하다.
   -- LEFT 와 RIGHT 는 위치가 중요하다.
  
  -- 1) LEFT [OUTER] JOIN
   -- 합치기에 사용한 두 테이블 중 왼편에 기술된 테이블의 컬럼수를 기준으로 JOIN
   -- 왼편에 작성된 테이블의 모든 행이 결과에 포함된다.
   -- 즉, 일치하지 않는 값이 있어서 JOIN 되지 않는 행도 결과에 포함됨
  
	 -- ANSI
	 SELECT EMP_ID, EMP_NAME, DEPT_TITLE
	 FROM EMPLOYEE 
	 LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
    -- DEPT TITLE 값을 가지고 있지 않는 '하동운', '이오리' 가 출력된다. 총 23행

	 -- ORACLE
	 SELECT EMP_ID, EMP_NAME, DEPT_TITLE
	 FROM EMPLOYEE, DEPARTMENT
	 WHERE DEPT_CODE = DEPT_ID(+);
	  -- 반대쪽 테이블에 '+' 기호를 붙이면 외부 조인이 된다.

  -- 2) RIGHT [OUTER] JOIN
	 -- ANSI
	 SELECT EMP_ID, EMP_NAME, DEPT_TITLE
	 FROM EMPLOYEE 
	 RIGHT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
    -- 마케팅부, 국내영업부, 해외영업3부에 해당하는 지원이 없어도 모두 출력된다. 총 24행

	 -- ORACLE
	 SELECT EMP_ID, EMP_NAME, DEPT_TITLE
	 FROM EMPLOYEE, DEPARTMENT
	 WHERE DEPT_CODE(+) = DEPT_ID;

  -- 3) FULL [OUTER] JOIN
   -- 합치기에 사용한 두 테이블이 가진 모든 행 결과에 포함
	 -- ANSI
	 SELECT EMP_ID, EMP_NAME, DEPT_TITLE
	 FROM EMPLOYEE 
	 FULL OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
    -- LEFT 와 RIGHT 의 결과를 합쳐서 출력됨

	 -- ORACLE 에는 FULL 구문이 없다!

-- ===========================================================================================

 -- 3. 교차 조인(CROSS JOIN = CARTESIAN PRODUCT)
  -- 조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방법
  -- > 보통 JOIN 구문을 잘못 작성하는 경우 CROSS JOIN 의 결과가 조회됨

	SELECT EMP_NAME, DEPT_TITLE
	FROM EMPLOYEE 
	CROSS JOIN DEPARTMENT;
	 
-- ===========================================================================================

 -- 4. 비등가 조인 (NON EQUAL JOIN)
  -- '='(등호)를 사용하지 않는 JOIN 문
  -- 지정한 컬럼값이 일치하는 경우가 아닌, 값의 범위에 포함되는 행들을 연결하는 방식 
	
	SELECT * FROM SAL_GRADE;

	-- 사원 급여에 따른 급여 등급 파악
  SELECT EMP_NAME, SAL_LEVEL FROM EMPLOYEE; 
	
	SELECT EMP_NAME, SALARY, S.SAL_LEVEL
	FROM EMPLOYEE
	JOIN SAL_GRADE S ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);

-- ===========================================================================================

 -- 5. 자체 조인(SELF JOIN)
	-- 같은 테이블 간 조인
	-- 자기 자신과 조인
	-- 같은 테이블이 2개 있다고 생각하고 JOIN 을 작성하면 되며, 
	-- 테이블마다 별칭을 작성하여 효율적으로 관리 필요
	
	-- 사번, 이름, 사수의 사번, 사수의 이름 조회
	 -- 단, 사수가 없으면 '없음', '-' 조회
  
	-- ANSI
	SELECT E1.EMP_ID "사번", E1.EMP_NAME "사원명", NVL(E1.MANAGER_ID, '없음') "사수의 사번", NVL(E2.EMP_NAME, '없음') "사수명"
	FROM EMPLOYEE E1
	LEFT OUTER JOIN EMPLOYEE E2 ON(E1.MANAGER_ID = E2.EMP_ID);
   -- 사수가 없는 사람도 출력하기 위해 LEFT 사용
   -- NULL 값을 가지는 걸 방지하기 위해 NVL 함수 활용
 	 -- 같은 테이블이 2개 있는 것이기 때문에 별칭을 주어 구분을 확실히

	-- ORACLE
  SELECT E1.EMP_ID "사번", E1.EMP_NAME "사원명", NVL(E1.MANAGER_ID, '없음') "사수의 사번", NVL(E2.EMP_NAME, '없음') "사수명"
	FROM EMPLOYEE E1, EMPLOYEE E2
	WHERE E1.MANAGER_ID = E2.EMP_ID;
	
-- ===========================================================================================

 -- 6. 자연 조인 (NATURAL JOIN)
	-- 동일한 타입과 이름을 가진 컬럼이 있는 테이블 간 조인을 간단히 표현하는 방법
  -- 반드시 두 테이블 간 동일한 컬럼명, 타입을 가진 컬럼 필요

	SELECT JOB_CODE FROM EMPLOYEE;
	SELECT JOB_CODE FROM JOB;

	SELECT EMP_NAME, JOB_NAME FROM EMPLOYEE
	JOIN JOB USING (JOb_CODE);
 	 -- EMPLOYEE 와 JOB 테이블 간 조인
	
	SELECT EMP_NAME, JOB_NAME FROM EMPLOYEE
	NATURAL JOIN JOB;
	 -- NATRUAL JOIN 을 사용한 방법. 위 207~209 코드와 결과가 동일함
	 
  -- * NATURAL JOIN 을 잘못 사용하면 CROSS JOIN 한 결과가 발생되니 주의!
 
-- ===========================================================================================

 -- 7. 다중 조인 
	-- N 개의 테이블을 조인할 때 사용 (순서 중요!!)
	
	-- 사원 이름, 부서명, 지역명 조회
	SELECT * FROM EMPLOYEE;
	SELECT * FROM DEPARTMENT;
	SELECT * FROM LOCATION;
	 -- EMPLOYEE 와 DEPARTMENT 간 연결고리는 있으나, EMPLOYEE 와 LOCATION 간 연결고리는 없다.
	 -- DEPARTMENT 와 LOCATION 의 연결고리가 있으므로 EMPLOYEE 와 LOCATION 을 조인하기 위해서 DEPARTMENT 를 거친다.
	  -- 따라서 순서가 중요하다
	  
	-- ANSI
	SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
	FROM EMPLOYEE
	JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
	JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);	
	
	-- ORACLE
  SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
  FROM EMPLOYEE, DEPARTMENT, LOCATION
  WHERE DEPT_CODE = DEPT_ID -- EMLOYEE + DEPARTMENT
  AND LOCATION_ID = LOCAL_CODE; -- (EMLOYEE + DEPARTMENT) + LOCATION
  
  -- 다중 조인 연습 문제
   -- Q. 직급이 대리이면서, 아시아 지역에 근무하는 직원의 사번, 이름, 직급명, 부서명, 근무지역명, 급여 조회
  
  -- ANSI
  SELECT EMP_ID "사번", EMP_NAME "이름", JOB_NAME "직급", DEPT_TITLE "부서", LOCAL_NAME "근무지역", SALARY "급여"
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
  JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
  WHERE JOB_NAME = '대리' AND LOCAL_NAME LIKE 'ASIA%';
	
	-- ORACLE
	SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
	FROM EMPLOYEE E, JOB J, DEPARTMENT, LOCATION
	WHERE E.JOB_CODE = J.JOB_CODE 
	AND DEPT_CODE = DEPT_ID
	AND LOCATION_ID = LOCAL_CODE
	AND JOB_NAME = '대리'
	AND LOCAL_NAME LIKE 'ASIA%';

-- ===========================================================================================

-- JOIN 종합 연습 문제


  -- 1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.
	SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
	FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	JOIN JOB USING (JOB_CODE)
	WHERE SUBSTR(EMP_NO, 8 , 1) = 2 	-- WHERE EMP_NO LIKE '7%'
	AND SUBSTR(EMP_NO, 1, 1) = 7
	AND INSTR(EMP_NAME, '전') = 1; 	-- AND EMP_NAME LIKE '전%';

	-- 2. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 직급명, 부서명을 조회하시오.
	SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
	FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	JOIN JOB USING (JOB_CODE) -- NATURAL JOIN JOB
	WHERE EMP_NAME LIKE '%형%';

	-- 3. 해외영업 1부, 2부에 근무하는 사원의 사원명, 직급명, 부서코드, 부서명을 조회하시오.
	SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
	FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	JOIN JOB USING (JOB_CODE)
	WHERE DEPT_TITLE = '해외영업1부' OR DEPT_TITLE = '해외영업2부'; -- WHERE DEPT_TITLE IN ('해외영업1부', '해외영업2부')
		
	-- 4. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.
	SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
	FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
	WHERE BONUS IS NOT NULL;
	
	-- 5. 부서가 있는 사원의 사원명, 직급명, 부서명, 지역명 조회 
	SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
	FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
	-- WHERE DEPT_CODE IN NOT NULL; - < 이 부분 추가하면 오류 
	 -- 왜? 오류?

	-- 6. 급여등급별 최소급여(MIN_SAL)를 초과해서 받는 직원들의 사원명, 직급명,급여, 연봉(보너스포함)을 조회하시오. (연봉에 보너스포인트를 적용하시오.)
	SELECT EMP_NAME, JOB_NAME, SALARY, (SALARY * (1 + NVL(BONUS, 0))) * 12 AS "연봉"
	FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
	JOIN SAL_GRADE USING (SAL_LEVEL)
	WHERE SALARY > MIN_SAL;
	-- 주의사항!
	-- NATURAL JOIN 을 다중조인에서 사용 시 SELECT 절에 NATURAL JOIN 에서 사용되었을 연결고리 컬럼을 반드시 작성해야 함
	
	-- 7. 한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.
	SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
	FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
	JOIN NATIONAL USING (NATIONAL_CODE)
	WHERE NATIONAL_NAME IN ('한국', '일본');

	-- 8. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.(SELF JOIN 사용)
	SELECT E1.EMP_NAME 사원명, E1.DEPT_CODE 부서코드, E2.EMP_NAME 동료이름
	FROM EMPLOYEE E1
	JOIN EMPLOYEE E2 ON(E1.DEPT_CODE = E2.DEPT_CODE)
	WHERE E1.EMP_NAME != E2.EMP_NAME
	ORDER BY 사원명;

	-- 9. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하시오. (단, JOIN, IN 사용할 것)
	SELECT EMP_NAME, JOB_NAME, SALARY
	FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
	WHERE BONUS IS NULL
	AND JOB_CODE IN ('J4', 'J7');

  