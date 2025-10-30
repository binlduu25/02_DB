-- *** DML (DATA MANIPULATION LANGUAGE) : 데이터 조작 언어 ***

-- 테이블에 값을 삽임(INSERT), 수정(UPDATE), 삭제(DELETE) 구문

-- 테스트용 테이블 생성하기
	-- 원본 테이블 건드리지 않도록
CREATE TABLE EMPLOYEE2 AS SELECT * FROM EMPLOYEE;
CREATE TABLE DEPARTMENT2 AS SELECT * FROM DEPARTMENT;

-- 테이블 작성되었는지 확인
SELECT * FROM EMPLOYEE2; 
SELECT * FROM DEPARTMENT2;

-- ================================================================

-- 1. INSERT
	-- 테이블에 새로운 행을 추가하는 구문

	-- 1) INSERT INTO 테이블명 VALUES(데이터, 데이터, 데이터....);
   -- 테이블에 있는 모든 컬럼에 대한 값을 INSERT 할 때 사용
	INSERT INTO EMPLOYEE2
	VALUES('900', '홍길동', '991231-1234567', 'hong_gd@or.kr',
				 '01011111111', 'D1', 'J7', 'S3', 4300000, 0.2, '200', SYSDATE, NULL, 'N');
	SELECT * FROM EMPLOYEE2 WHERE EMP_ID = '900'; 

	ROLLBACK;
	
	-- 2) INSERT INTO 테이블명 (컬럼명1, 컬럼명2, 컬럼명3....) 
	--		VALUES(데이터, 데이터, 데이터....);
	 -- 테이블에 내가 선택한 컬럼에 대한 값만 INSERT
	 -- 선택하지 않은 컬럼 값은 NULL, DEFAULT 값 존재 시 DEFAULT 설정값으로 삽입됨
	INSERT INTO EMPLOYEE2(EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY)
	VALUES('900', '홍길동', '991231-1234567', 'hong_gd@or.kr',
				 '01011111111', 'D1', 'J7', 'S3', 4300000);
	SELECT * FROM EMPLOYEE2 WHERE EMP_ID = '900'; 

	COMMIT; 
	-- 홍길동 데이터 영구저장
	-- COMMIT 후에는 ROLLBACK 수행해도 되돌려지지 않는다. (데이터가 영구 저장됨)

	-- 3) INSERT 시 VALUES 대신 서브쿼리 사용 가능
	CREATE TABLE EMP_O1(
		EMP_ID NUMBER,
		EMP_NAME VARCHAR2(30), -- EMP_NAME 이라는 컬럼을 VARCHAR2 타입의 30바이트까지 저장가능하게 만들겠다
		DEPT_TITLE VARCHAR2(20));
	
	SELECT * FROM EMP_O1;
	
	-- 아래에 서브쿼리를 하나 만들고 결과(RESULT SET)을 EMP_01 테이블에 INSERT 
	 --> 주의사항 : SELECT 조회 결과의 데이터 타입, 컬럼 개수가 INSERT 하려는 테이블의 컬럼과 일치해야 함
	SELECT EMP_ID, EMP_NAME, DEPT_TITLE
	FROM EMPLOYEE2
	LEFT JOIN DEPARTMENT2 ON (DEPT_CODE = DEPT_ID);

	-- INSERT 수행
	INSERT INTO EMP_O1(
		SELECT EMP_ID, EMP_NAME, DEPT_TITLE
		FROM EMPLOYEE2
		LEFT JOIN DEPARTMENT2 ON (DEPT_CODE = DEPT_ID)
	);

	SELECT * FROM EMP_O1;

-- ================================================================

-- 2. UPDATE (내용 바꾸거나 추가해서 최신화)
	-- 테이블에 기록된 컬럼값 수정
	
	-- 1)
	/* [작성법]
 	UPDATE 테이블명
 	SET 컬럼명 = 바꿀값
 	[WHERE 컬럼명 비교연산자 비교값];
 	
 	-- WHERE 절은 옵션이지만 조건 중요
 	WHERE 절 설정하지 않을 시 전체 열을 바꾸게 됨	 
  */

	-- DEPARTEMENT2 테이블에서 DEPT_ID 'D9' 부서 조회
	SELECT * FROM DEPARTMENT2 WHERE DEPT_ID = 'D9';
	
	-- DEPARTEMENT2 테이블에서 DEPT_ID 'D9' 부서의 DEPT_TITLE 을 '전략기획팀' 으로 수정
	UPDATE DEPARTMENT2
	SET DEPT_TITLE = '전략기획팀'
	WHERE DEPT_ID = 'D9';

	SELECT * FROM DEPARTMENT2 WHERE DEPT_ID = 'D9';

	-- * 조건절 설정하지 않고 UPDATE 구문 실행
	UPDATE DEPARTMENT2
	SET DEPT_TITLE = '기술연구팀';
	
	SELECT * FROM DEPARTMENT2;
	
	-- EMPLOYEE2 테이블에서 BONUS를 받지 않는 사원의 보너스를 0.1로 수정
	UPDATE EMPLOYEE2
	SET BONUS = 0.1
	WHERE BONUS IS NULL;

	SELECT * FROM EMPLOYEE2;

	ROLLBACK;

 	-- 2) 여러 컬럼 한번에 수정 시 콤마로 컬럼 구분하기
	 -- D9 / 총무부 > D0 / 전략기획팀 으로 수정
	UPDATE DEPARTMENT2
	SET DEPT_ID = 'D0', DEPT_TITLE = '전략기획팀'
	WHERE DEPT_ID = 'D9' AND DEPT_TITLE = '총무부';

	SELECT * FROM DEPARTMENT2;

	-- 3) UPDATE 에서도 서브쿼리 사용 가능
	-- [작성법] 
	 -- UPDATE 테이블명 SET 
	 -- 컬럼명 = (서브쿼리)
	-- EMPLOYEE2 테이블에서 방명수 사원의 급여와 보너스율을 유재식 사원과 동일하게 변경 
	 -- 유재식 급여 조회
	 SELECT SALARY FROM EMPLOYEE2 WHERE EMP_NAME = '유재식'; -- 3,400,000
	 SELECT BONUS FROM EMPLOYEE2 WHERE EMP_NAME = '유재식'; -- 0.2
	 
	 UPDATE EMPLOYEE2
	 SET SALARY = (SELECT SALARY FROM EMPLOYEE2 WHERE EMP_NAME = '유재식'),
	 		 BONUS = (SELECT BONUS FROM EMPLOYEE2 WHERE EMP_NAME = '유재식')
	 WHERE EMP_NAME = '방명수';

	SELECT EMP_NAME, SALARY, BONUS
	FROM EMPLOYEE2
	WHERE EMP_NAME IN ('유재식', '방명수');
	
-- ================================================================

-- 3. MERGE(병합)

-- 구조가 같은 2개의 테이블을 하나로 합침
 -- 테이블에서 지정하는 조건의 값이 존재하면 UPDATE, 없으면 INSERT

	-- 1) 임의의 테이블 두 개 생성
	CREATE TABLE EMP_M01 AS SELECT * FROM EMPLOYEE;
	CREATE TABLE EMP_M02 AS SELECT * FROM EMPLOYEE WHERE JOB_CODE = 'J4';

	-- 2) 조회
	SELECT * FROM EMP_M01; -- 23명
	SELECT * FROM EMP_M02; -- 4명

	-- 3) EMP_02 에 새로운 행 생성 
	INSERT INTO EMP_M02 VALUES(999, '곽두원', '561016-1234567', 'kwack_dw@or.kr', '01900100020', 
																 'D9', 'J4', 'S1', 9000000, 0.5, NULL, SYSDATE, NULL, NULL);	
	SELECT * FROM EMP_M01; -- 23명
	SELECT * FROM EMP_M02; -- 5명
	
	UPDATE EMP_M02 SET SALARY = 0;

	-- 아래 코드 설명 : 
	 -- M01 데이터와 MO2 데이터 비교하고
 	 -- M01 데이터를 M02 데이터로 수정(UPDATE)하고
	 -- MATCH 되지 않는 데이터가 있을 시 INSERT 하겠다. -- 24번째 행 추가
	MERGE INTO EMP_M01 USING EMP_M02 ON (EMP_M01.EMP_ID = EMP_M02.EMP_ID)
	WHEN MATCHED THEN
	UPDATE SET
		EMP_M01.EMP_NAME = EMP_M02.EMP_NAME,
		EMP_M01.EMP_NO = EMP_M02.EMP_NO,
		EMP_M01.EMAIL = EMP_M02.EMAIL,
		EMP_M01.PHONE = EMP_M02.PHONE,
		EMP_M01.DEPT_CODE = EMP_M02.DEPT_CODE,
		EMP_M01.JOB_CODE = EMP_M02.JOB_CODE,
		EMP_M01.SAL_LEVEL = EMP_M02.SAL_LEVEL,
		EMP_M01.SALARY = EMP_M02.SALARY,	
		EMP_M01.BONUS = EMP_M02.BONUS,
		EMP_M01.MANAGER_ID = EMP_M02.MANAGER_ID,
		EMP_M01.HIRE_DATE = EMP_M02.HIRE_DATE,
		EMP_M01.ENT_DATE = EMP_M02.ENT_DATE,
		EMP_M01.ENT_YN = EMP_M02.ENT_YN
	WHEN NOT MATCHED THEN -- MATCH 가 되지 않을 때 병합하겠다
	INSERT VALUES(
		EMP_M02.EMP_ID, EMP_M02.EMP_NAME, EMP_M02.EMP_NO, EMP_M02.EMAIL, 
	  EMP_M02.PHONE, EMP_M02.DEPT_CODE, EMP_M02.JOB_CODE, EMP_M02.SAL_LEVEL, 
	  EMP_M02.SALARY, EMP_M02.BONUS, EMP_M02.MANAGER_ID, EMP_M02.HIRE_DATE, 
	  EMP_M02.ENT_DATE, EMP_M02.ENT_YN
	);

	SELECT * FROM EMP_M01; 

-- ================================================================

-- 4. DELETE
 -- 테이블의 행 삭제 구문
 -- [작성법]
 -- DELETE FROM 테이블명 [WHERE 조건설정];
 -- * WHERE 절 설정 안 할 시 모든 행 삭제됨

	COMMIT; -- 위 3. 까지 했던 내용 COMMIT
	
	SELECT * FROM EMPLOYEE2 WHERE EMP_NAME = '홍길동';
	
	-- 홍길동 삭제
	DELETE FROM EMPLOYEE2 WHERE EMP_NAME ='홍길동';
	ROLLBACK; -- 마지막 COMMIT 시점으로 되돌아감
	
	-- EMPLOYEE2 테이블 행 전체 삭제
	DELETE FROM EMPLOYEE2; -- 24행 삭제
	
	SELECT * FROM EMPLOYEE2;
	
	ROLLBACK;
	
	SELECT * FROM EMPLOYEE2;

-- ================================================================

-- 5. TRUNCATE(DML 아님, DDL 구문임)
 -- 테이블의 전체 행을 삭제하는 DDL
 -- DDL 보다 수행속도 빠름
 -- ROLLBACK 을 통해 복구할 수 없다

	CREATE TABLE EMPLOYEE3 AS SELECT * FROM EMPLOYEE2;
	SELECT * FROM EMPLOYEE3;

	TRUNCATE TABLE EMPLOYEE3; -- TABLE 자체를 삭제하는 것은 아니고 테이블 내 행들을 삭제함
	
	ROLLBACK; -- ROLLBACK 해도 복구 안 됨


	


 
