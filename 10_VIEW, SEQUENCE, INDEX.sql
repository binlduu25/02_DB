/* VIEW
 * 
 * 	- 논리적 가상 테이블
 * 	-> 테이블 모양을 하고는 있지만, 실제로 값을 저장하고 있진 않음.
 * 
 *  - SELECT문의 실행 결과(RESULT SET)를 저장하는 객체
 * 
 * 
 * ** VIEW 사용 목적 **
 *  1) 복잡한 SELECT문을 쉽게 재사용하기 위해.
 *  2) 테이블의 진짜 모습을 감출 수 있어 보안상 유리.
 * 
 * ** VIEW 사용 시 주의 사항 **
 * 	1) 가상의 테이블(실체 X)이기 때문에 ALTER 구문 사용 불가.
 * 	2) VIEW를 이용한 DML(INSERT,UPDATE,DELETE)이 가능한 경우도 있지만
 *     제약이 많이 따르기 때문에 조회(SELECT) 용도로 대부분 사용.
 * 
 * 
 *  ** VIEW 작성법 **
 *  CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름 [컬럼 별칭]
 *  AS 서브쿼리(SELECT문)
 *  [WITH CHECK OPTION]
 *  [WITH READ OLNY];
 * 
 * 
 *  1) OR REPLACE 옵션 : 
 * 		기존에 동일한 이름의 VIEW가 존재하면 이를 변경
 * 		없으면 새로 생성
 * 
 *  2) FORCE | NOFORCE 옵션 : 
 *    FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
 *    NOFORCE(기본값): 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성
 *    
 *  3) 컬럼 별칭 옵션 : 조회되는 VIEW의 컬럼명을 지정
 * 
 *  4) WITH CHECK OPTION 옵션 : 
 * 		옵션을 지정한 컬럼의 값을 수정 불가능하게 함.
 * 
 *  5) WITH READ OLNY 옵션 :
 * 		뷰에 대해 SELECT만 가능하도록 지정.
 * */

-- VIEW 를 만들기 위해서는 권한이 필요함
GRANT CREATE VIEW TO c##sjh;

CREATE VIEW V_EMP AS SELECT * FROM EMPLOYEE;
-- ORA-01031: 권한이 불충분합니다
 -- > 권한 부여 필요
  -- SYS 계정 접속 필요
	-- > 권한 부여 후 VIEW 객체 생성 완료 확인

SELECT * FROM V_EMP;

	-- 사번, 이름, 부서명, 직급명 조회하기 위한 VIEW 생성
	
	CREATE OR REPLACE VIEW V_EMP AS 
	SELECT EMP_ID "사번", EMP_NAME "이름", NVL(DEPT_TITLE, '없음') "부서명", JOB_NAME "직급"
	FROM EMPLOYEE
	JOIN JOB USING (JOB_CODE)
	LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	ORDER BY EMP_ID;
	-- > ORA-00955: 기존의 객체가 이름을 사용하고 있습니다.
	-- V_EMP 를 사용하고 있기 때문에 발생
	-- > OR REPLACE 사용

	-- 직급명이 대리인 사원 모두 조회
	 --> VIEW 조회 결과로 보이는 컬럼명만을 이용해야 함
	SELECT * FROM V_EMP
	WHERE 직급 = '대리'
	ORDER BY 이름;

-----------------------------------------------------------

-- VIEW 를 이용해서 DML 사용하기 + 문제점 확인

-- DEPARTMENT 테이블 복사한 DEPT_COPY2 생성 (테이블로)

CREATE TABLE DEPT_COPY2 AS SELECT * FROM DEPARTMENT;

-- DEPT_COPY2 테이블 이용해 V_DCOPY2 VIEW 생성
-- DEPT_ID 와 LOCATION_ID 만 이용
CREATE OR REPLACE VIEW V_DCOPY2
AS SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2;

SELECT * FROM V_DCOPY2;
SELECT * FROM DEPT_COPY2;

-- V_DCOPY2 라는 VIEW 에 INSERT 수행

INSERT INTO V_DCOPY2 VALUES('D0', 'L2');

SELECT * FROM V_DCOPY2;  
-- > 가상테이블 VIEW 에 INSERT 성공
SELECT * FROM DEPT_COPY2;
-- > 하지만 원본테이블인 DEPT_COPY2 에도 DEPT_TITLE 의 NULL 값을 포함한 의도하지 않은 행이 INSERT 됨을 확인
 -- > 따라서 VIEW DML 을 하는 행위는 데이터무결성을 해칠 수 있기에 지양 필요

-- WITH READ ONLY 옵션 사용
 -- > VIEW 를 이용한 DML (INSERT, UPDATE, DELETE) 방지하기 위해 사용
	CREATE OR REPLACE VIEW V_DCOPY2
	AS SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2
	WITH READ ONLY; -- 읽기전용 옵션
	
	INSERT INTO V_DCOPY2 VALUES('D0', 'L2');
	-- ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.

----------------------------------------------------------------------------------------

/* SEQUENCE(순서, 연속)
 * - 순차적으로 일정한 간격의 숫자(번호)를 발생시키는 객체
 *   (번호 생성기)
 * 
 * *** SEQUENCE 왜 사용할까?? ***
 * PRIMARY KEY(기본키) : 테이블 내 각 행을 구별하는 식별자 역할
 * 						 					 NOT NULL + UNIQUE의 의미를 가짐
 * 
 * PK가 지정된 컬럼에 삽입될 값을 생성할 때 SEQUENCE를 이용하면 좋다!
 * 
 *   [작성법]
  CREATE SEQUENCE 시퀀스이름
  [STRAT WITH 숫자] -- 처음 발생시킬 시작값 지정, 생략하면 1이 기본
  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 1이 기본
  [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정, 생략하면 기본값은 10^27 - 1 (즉, 매우 큰 값)입니다 / NOMAXVALUE를 사용하면 최대값 제한이 없음을 의미
  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 , 기본값은 -10^26 /  NOMINVALUE를 사용하면 최소값 제한이 없음을 의미
  [CYCLE | NOCYCLE] -- 값 순환 여부 지정 , 기본값은 NOCYCLE
		
		-- CYCLE: 값이 최대값에 도달하면 다시 최소값부터 순환
		-- NOCYCLE: 값을 순환하지 않고, 최대값에 도달하면 오류를 발생시킴
  
  [CACHE 시퀀스개수 | NOCACHE] -- 기본값은 20
	-- 시퀀스의 캐시 메모리는 할당된 크기만큼 미리 다음 값들을 생성해 저장해둠
	--> 시퀀스 호출 시 미리 저장되어진 값들을 가져와 반환하므로 
	--  매번 시퀀스를 생성해서 반환하는 것보다 DB속도가 향상됨.
 * 
 * 
 * ** 사용법 **
 * 
 * 1) 시퀀스명.NEXTVAL : 다음 시퀀스 번호를 얻어옴.
 * 						 (INCREMENT BY 만큼 증가된 수)
 * 						 단, 생성 후 처음 호출된 시퀀스인 경우
 * 						 START WITH에 작성된 값이 반환됨.
 * 
 * 2) 시퀀스명.CURRVAL : 현재 시퀀스 번호를 얻어옴.
 * 						 단, 시퀀스가 생성 되자마자 호출할 경우 오류 발생.
 * 						== 마지막으로 호출한 NEXTVAL 값을 반환
 * */

-- 시퀀스 객체 생성

CREATE SEQUENCE SEQ_TEST_NO
START WITH 100 -- 시작 번호 100번부터 시작
INCREMENT BY 5 -- 5씩 증가, = NEXTVAL 호출 시 5씩 증가
MAXVALUE 150 -- 증가로 도달 가능한 최대값 150
NOMINVALUE -- 최소값 한계 없음
NOCYCLE -- 반복 없음, 최대값 150에 도달 뒤 다시 실행시키면 에러 발생
NOCACHE; -- 미리 만들어 둘 시퀀스 번호 없음

-- 시퀀스 테스트용 테이블 생성

CREATE TABLE TB_TEST_SEQ(
	TEST_NO NUMBER PRIMARY KEY, 
	TEST_NAME VARCHAR2(30) NOT NULL);

SELECT * FROM TB_TEST_SEQ;

-- 테스트용 테이블에 행 삽입 전 현재 시퀀스 번호 확인
SELECT SEQ_TEST_NO.CURRVAL FROM DUAL; 
 -- ORA-08002: 시퀀스 SEQ_TEST_NO.CURRVAL은 이 세션에서는 정의 되어 있지 않습니다
 -- CURRVAL 은 가장 최근에 호출된 NEXTVAL() 값을 반환함을 뜻함
 -- > NEXTVAL()을 호출한 적이 없기에 오류 발생한다
 -- > 해결방법 : NEXTVAL() 생성
	SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL; -- 최초 호출. 100 생성됨
	-- 시퀀스 생성 후 첫 NEXTVAL 은 START WITH 값인 100
	-- NEXTVAL 은 호출할 때마다 INCREMENT BY 에 작성된 수만큼 증가
	SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;
	SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;
	SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;
	SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;

-- TB_TEST_SEQ 테이블에 PK로 지정된 컬럼 값에 시퀀스로 생성한 값 삽입
INSERT INTO TB_TEST_SEQ
VALUES(SEQ_TEST_NO.NEXTVAL, '짱구');
INSERT INTO TB_TEST_SEQ
VALUES(SEQ_TEST_NO.NEXTVAL, '철수');
INSERT INTO TB_TEST_SEQ
VALUES(SEQ_TEST_NO.NEXTVAL, '유리');

SELECT * FROM TB_TEST_SEQ;

---------------------------------------------------------------------

-- UPDATE 에서 시퀀스 사용
-- '짱구'의 PK 컬럼값을 SEQ_TEST_NO 의 다음 생성값으로 변경

UPDATE TB_TEST_SEQ SET TEST_NO = SEQ_TEST_NO.NEXTVAL
WHERE TEST_NAME = '짱구';
-- ORA-08004: 시퀀스 SEQ_TEST_NO.NEXTVAL exceeds MAXVALUE은 사례로 될 수 없습니다
 -- MAXVALUE 의 다음 값을 추출하려 할 때는 해당 에러 발생

----------------------------------------------------------------------

-- SEQUENCE 변경 (ALTER)
 -- START WITH 빼고 모두 변경 가능

	-- [작성법]
	/*
	ALTER SEQUENCE 시퀀스이름
	[INCREMENT BY 숫자]
	[MAXVALUE 숫자 | NOMAXVALUE] 
	[MINVALUE 숫자 | NOMINVALUE]
	[CYCLE | NOCYCLE]
	[CACHE 바이트크기 | NOCACHE]
	*/

-- SEQ_TEST_NO 의 MAXVALUE 값을 200으로 수정

ALTER SEQUENCE SEQ_TEST_NO
MAXVALUE 200;

SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;

--- VIEW, SEQUENCE 삭제

DROP VIEW V_DCOPY2;

DROP SEQUENCE SEQ_TEST_NO;

----------------------------------------------------------------------------------------------------------

-- INDEX
 -- 내부구조는 B*트리로 되어 있다
 -- B*트리 : 자료 구조와 관련 
 -- 검색 특화 개체

------------------------------------------------

/* INDEX(색인)
 * - SQL 구문 중 SELECT 처리 속도를 향상 시키기 위해 컬럼에 대하여 생성하는 객체
 * 
 * - 인덱스 내부 구조는 B* 트리(B-star tree) 형식으로 되어있음.
 * 
 * ** INDEX의 장점 **
 * - '이진 트리 형식'으로 구성되어 자동 정렬 및 검색 속도 증가.
 * 
 * - 조회 시 테이블의 전체 내용을 확인하며 조회하는 것이 아닌 인덱스가 지정된 컬럼만을 이용해서 조회하기 때문에 시스템 부하 하락. 
 * 
 * ** 인덱스의 단점 **
 * - 데이터 변경(INSERT,UPDATE,DELETE) 작업 시 이진 트리 구조에 변형이 일어남
 *    -> DML 작업이 빈번한 경우 시스템 부하가 늘어 성능이 저하됨.
 * 
 * - 인덱스도 하나의 객체이다 보니 별도 저장공간이 필요(메모리 소비)
 * 
 * - 인덱스 생성 시간이 필요함.
 * 
 *  [작성법]
 *  CREATE [UNIQUE] INDEX 인덱스명
 *  ON 테이블명 (컬럼명[, 컬럼명 | 함수명]);
 * 
 *  DROP INDEX 인덱스명;
 * 
 *  ** 인덱스가 자동 생성되는 경우 **
 * 
 *  -> PK 또는 UNIQUE 제약조건이 설정된 컬럼에 대해 UNIQUE INDEX가 자동 생성된다. 

 * PK에 자동 생성되는 이유 : 기본 키는 중복을 허용하지 않고, NOT NULL이어야 하기 때문이다.
 * UNIQUE 제약조건 설정 컬럼에서 자동생성 되는 이유 : 중복을 허용하지 않는 고유 값을 보장해야하기 때문이다.
 * */

SELECT ROWID, EMP_ID, EMP_NAME FROM EMPLOYEE;

-- ROWID : 오라클에서 각 행의 고유한 주소를 나타내는 가상 컬럼
-- ROWID 와 INDEX 의 관계
 -- INDEX 가 ROWID 를 저장하고 있음
 -- INDEX 는 컬럼의 값과 해당 행의 ROWID 를 매핑해서 저장함
 -- 즉, INDEX 의 핵심 역할은 컬럼값 -> 해당 행의 ROWID 를 통해 빠르게 찾아냄

-- 현재 사용자에 생성된 INDEX 목록 조회하기
SELECT INDEX_NAME, TABLE_NAME, UNIQUENESS, STATUS FROM USER_INDEXES;
/* 
	INDEX_NAME : 인덱스 이름
	TABLE_NAME : 인덱스가 적용된 테이블명
	UNIQUENESS : UNIQUE 여부 (UNIQUE/NONUNIQUE)
	STATUS : VALID(정상)/UNUSABLE(비활성화)
*/

-- 인덱스 성능 확인용 테이블 생성
CREATE TABLE TB_IDX_TEST(
	TEST_NO NUMBER PRIMARY KEY, -- 자동으로 UNIQUE INDEX 생성
	TEST_ID VARCHAR2(20) NOT NULL);

-- 샘플 데이터 다수 삽입하기 위해 반복문 사용
 -- PL/SQL 사용
 -- 조건문(IF/CASE), 반복문(LOOP/WHILE), 변수 선언 등..
 
BEGIN
	FOR I IN 1..1000 -- I 는 1부터 1000까지 반복(수업에선 1,000,000 사용)
		LOOP
			INSERT INTO TB_IDX_TEST
			VALUES(I, 'TEST' || I);
		END LOOP;
	COMMIT; -- 모든 삽입 작업을 커밋
END;

SELECT COUNT(*) FROM TB_IDX_TEST;
-- 행이 1000 개 들어갔음을 확인

-- 인덱스를 사용해 검색하는 방법
 -- > WHERE 절에 INDEX 가 지정된 컬럼 언급하기
-- 인덱스 지정되지 않은 컬럼 : TEST_ID 에서 
	SELECT * FROM TB_IDX_TEST
	WHERE TEST_ID = 'TEST999';

-- 인덱스 O
-- TEST_NO 가 500000 인 행 조회
SELECT * FROM TB_IDX_TEST
WHERE TEST_NO = 999; 
-- 보통 10~30배 차이

 -- TEST_ID 와 TEST_NO 을 비교해보면 속도 차이 가늠 가능
