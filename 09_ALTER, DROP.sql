-- DDL (DATA DEFINITION LANGUAGE) :  데이터 정의 언어
-- 객체 만들고, 바꾸고, 삭제하는 데이터 언어 정의

--------------------------------------------------------------------------------------------------
-- ALTER (바꾸다, 수정하다, 변조하다)
 
 -- 테이블에서 수정할 수 있는 것
	
	-- 1) 제약 조건 (추가/삭제) 
 	 -- ** 이미 작성된 제약 조건을 수정하는 것은 불가하다. 삭제 후 다시 추가하는 방식으로 해야 함

	-- 2) 컬럼 (추가/수정/삭제)

	-- 3) 이름변경 (테이블명, 컬럼명, 제약조건명)
--------------------------------------------------------------------------------------------------

-- 1. 제약조건 추가/삭제
	-- [작성법] 
	-- 1) 추가 : ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] 제약조건 (지정컬럼명) *이하 FK인 경우,  [REFERENCES 테이블명 [(컬럼명)]] 
	-- 2) 삭제 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

	-- DEPARTMENT 테이블 복사 (컬럼명, 데이터타입, NOT NULL 만 복사)
	CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT;
	
	SELECT * FROM DEPT_COPY;
	SELECT * FROM DEPARTMENT;
	-- DEPT_COPY 테이블과 DEPARTMENT 테이블을 비교해보면, 
   -- COMMENT 및 NOT NULL 제약조건을 제외한 나머지 제약조건 등이 복사가 되지 않았음

		-- DEPT_COPY 의 DEPT_TITLE 컬럼에 UNIQUE 추가해보기
		ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_TITLE_U UNIQUE(DEPT_TITLE);
	
		-- DEPT_COPY_TITLE_U 삭제하기
		ALTER TABLE DEPT_COPY DROP CONSTRAINT DEPT_COPY_TITLE_U;
	
	-- DEPT_COPY 테이블에 DEPT_TITLE 컬럼 내 NOT NULL 제약조건 추가/삭제 --
	
		ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_TITLE_NN NOT NULL(DEPT_TITLE);
		 -- ORA-00904: : 부적합한 식별자 
		 -- 에러 발생
		-- > NOT NULL 제약조건은 새로운 조건을 추가하는 것이 아닌 컬럼 자체에 NULL 허용 / 비허용을 제어하는 성질 변경의 형태로 인식
		
		-- > MODIFY 구문 사용하여 NULL 제어 
			-- DEPT_TITLE 에 NULL 비허용
			ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NOT NULL;	
			-- DEPT_TITLE 에 NULL 허용
			ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE NULL;

--------------------------------------------------------------------------------------------------

-- 2. 컬럼 (추가/수정/삭제)

 	-- 컬럼 추가
	-- ALTER TABLE 테이블명 ADD (컬럼명 데이터타입 [DEFAULT '값']);

	-- 컬럼 수정
	-- ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입; -- > 해당 컬럼 데이터타입 변경
	-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '값'; -- > DEFAULT 값 변경

	-- 컬럼 삭제
	-- ALTER TABLE 테이블명 DROP (삭제컬럼명);
	-- ALTER TABLE 테이블명 DROP COLUMN 삭제컬럼명; 

	SELECT * FROM DEPT_COPY;
		
		-- 추가해보기
		ALTER TABLE DEPT_COPY ADD (CNAME VARCHAR2(30));
		-- 전부 NULL 로 설정됨
		
		-- 기본값 설정해보기
		ALTER TABLE DEPT_COPY ADD (LNAME VARCHAR2(30) DEFAULT '한국');
		
		-- D10 개발1팀 추가
		INSERT INTO DEPT_COPY VALUES('D10', '개발1팀', 'L1', DEFAULT, DEFAULT); 
		-- ORA-12899: "C##SJH"."DEPT_COPY"."DEPT_ID" 열에 대한 값이 너무 큼(실제: 3, 최대값: 2)
		 -- 'D10' 은 영어 + 숫자 3글자
		-- > DEPT_ID 컬럼 데이터타입 수정
		ALTER TABLE DEPT_COPY MODIFY DEPT_ID VARCHAR2(3);

		-- > LNAME 기본값 'KOREA' 로 수정
		ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT 'KOREA';
		 -- > 변경 안 됨, 하지만 기본값 자체는 설정된 상태
		 -- > 아래 UPDATE 통해 변경시켜주어야 함

		UPDATE DEPT_COPY SET LNAME = DEFAULT
		WHERE LNAME = '한국';

		COMMIT;

		-- DEPT_COPY 모든 컬럼 삭제

		ALTER TABLE DEPT_COPY DROP (LNAME);
		ALTER TABLE DEPT_COPY DROP COLUMN CNAME;	
		ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;	
		ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;	
		
		ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;	
		-- ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다
		 -- 마지막 열까지 삭제 불가

		-- > 테이블 완전 삭제 해보기
		-- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
		DROP TABLE DEPT_COPY;
		
		-- 예제 위한 새 DEPARTMENT COPY 테이블 작성
		CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT;
			-- > 컬럼명, 데이터타입, NOT NULL 여부만 복사
			
		-- DEPT_COPY 테이블에 PK 추가 (컬럼 : DEPT_ID, 제약조건명 : D_COPY_PK)

		ALTER TABLE DEPT_COPY ADD CONSTRAINT D_COPY_PK PRIMARY KEY (DEPT_ID);

		-- 3. 이름 변경 (컬럼, 테이블, 제약조건명)

		-- 1) 컬럼명 변경 (DEPT_TITLE -> DEPT_NAME)
		ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;
		
		SELECT * FROM DEPT_COPY;

		-- 2) 제약조건명 변경
		ALTER TABLE DEPT_COPY RENAME CONSTRAINT D_COPY_PK TO DEPT_COPY_PK;

		-- 3) 테이블명 변경
		ALTER TABLE DEPT_COPY RENAME TO D_COPY; 

		SELECT * FROM D_COPY;

-------------------------------------------------------------------------------------

-- 4. 테이블 삭제

-- DROP TABLE 테이블명 [CASACADE CONSTRAINTS];

	-- 1) 관계가 형성되지 않은 테이블 삭제
	DROP TABLE D_COPY;

	-- 2) 관계가 형성된 테이블 삭제
	 
	 -- 샘플 테이블 작성
		-- 부모테이블
		CREATE TABLE TB1(
			TB1_PK NUMBER PRIMARY KEY,
			TB2_COL NUMBER); 	

		-- 자식테이블
		CREATE TABLE TB2(
			TB2_PK NUMBER PRIMARY KEY,
			TB2_COL NUMBER REFERENCES TB1 (TB1_PK));

		-- TB1, TB2 샘플 데이터 삽입
		INSERT INTO TB1 VALUES(1, 100);
		INSERT INTO TB1 VALUES(2, 200);
		INSERT INTO TB1 VALUES(3, 300);

		INSERT INTO TB2 VALUES(11, 1);
		INSERT INTO TB2 VALUES(12, 2);
		INSERT INTO TB2 VALUES(13, 3);

		COMMIT;
	
	 -- 부모인 TB1 삭제하려고 할 시
	 	DROP TABLE TB1;		
		-- ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다

		-- > 1) 자식, 부모 테이블 순서로 삭제하면 된다
		-- > 2) ALTER 이용하여 FK 제약조건 삭제 후 TB1 삭제
		-- > 3) DROP TABLE 삭제 옵션 CASCADE CONSTRAINTS 사용
		 -- > CASCADE CONSTRAINTS : 삭제하려는 테이블과 연결된 FK 제약조건 모두 삭제
		DROP TABLE TB1 CASCADE CONSTRAINTS;
		
		-- > TB2 는 독립적인 테이블로 남게됨


---------------------------------------------------------------------------

-- DDL 주의 사항
	-- 1) DDL 은 COMMIT / ROLLBACK 대상이 아님
 	-- 2) DDL 과 DML 구문 섞어서 수행하면 안 됨
		-- > DDL 수행 시 존재하고 있는 트랜잭션을 모두 DB 에 강제 COMMIT 시킴
		-- > DDL 종료 후 DML 구문을 수행함을 권장
	 -- > DDL : CREATE, ALTER, DROP
	 -- > INSERT, UPDATE, DELETE