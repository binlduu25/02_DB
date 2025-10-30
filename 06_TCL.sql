-- TCL (Transaction Control Language) : 트랜잭션 제어 언어
 -- COMMIT, ROLLBACK, SAVEPOINT

-- DML : 데이터 조작언어로 데이터의 삽입/삭제/수정
 --> 트랜잭션은 DML과 관련되어 있다

/* TRANSACTION 이란?
  - 데이터베이스의 논리적 연산 단위
  - 데이터 변경 사항(조작된 사항)을 묶어서 하나의 트랜잭션에 담아 처리
  - 트랜잭션의 대상이 되는 데이터 변경 사항 : INSERT, UPDATE, DELETE, MERGE
 
  EX1) INSERT 수행 ------------------------------------> DB 반영 (X)
  EX2) INSERT 수행 -----> 트랜잭션에 추가 ---> COMMIT -------------> DB 반영 (O)
  EX3) INSERT 10번 수행 --> 1개 트랜잭션에 10개 추가 --> ROLLBACK --> DB 반영 (X)
 
  1) COMMIT : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 DB 에 반영
 
  2) ROLLBACK : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 삭제 후 마지막 COMMIT 상태로 돌아감 (DB에 변경 내용 미반영)
  
  3) SAVEPOINT : 메모리 버퍼(트랜잭션)에 저장 지점을 정의 후 ROLLBACK 수행 시 전체 작업을 삭제하는 것이 아닌 저장 지점까지 일부 ROLLBACK
 
 
  [SAVEPOINT 사용법]
 
  ...
  SAVEPOINT "포인트명1";
 
  ...
  SAVEPOINT "포인트명2";
 
  ...
  ROLLBACK TO "포인트명1"; -- 포인트1 지점까지 데이터 변경사항 삭제

  ** SAVEPOINT 지정 및 호출 시 이름에 ""(쌍따옴표) 붙여야함 !!! ***
 
 */	

-- ============================================================================
-- 새로운 데이터 INSERT

	SELECT * FROM DEPARTMENT2;
	INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
	INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
	INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');

	-- > 지금까지는 DB에 영구 저장된 것이 아님, 트랜잭션에 INSERT 3개가 들어가 있는 상태

	ROLLBACK; -- 마지막 COMMIT 시점까지 돌아감
	SELECT * FROM DEPARTMENT2; -- 개발 1,2,3 팀 삭제
	
	-- INSERT 후 COMMIT 해보기
	INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
	INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
	INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');
	SELECT * FROM DEPARTMENT2;

	COMMIT; -- COMMIT 후 ROLLBACK 해도 사라지지 않음
	
	-- ============================================================================
	-- SAVEPOINT 확인
	
	INSERT INTO DEPARTMENT2 VALUES('T4', '개발4팀', 'L2');
	SAVEPOINT "SP1"; -- SAVEPOINT 지정
	
	INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
	SAVEPOINT "SP2"; -- SAVEPOINT 지정
	
	INSERT INTO DEPARTMENT2 VALUES('T6', '개발6팀', 'L2');
	SAVEPOINT "SP3"; -- SAVEPOINT 지정
	
	ROLLBACK TO "SP1";
	SELECT * FROM DEPARTMENT2;
	-- SP2 와 SP3 의 세이브포인트도 사라지기 때문에 ROLBBACK "SP2"; 로 돌아가려 해도 오류 발생
	
	-- 개발팀 전체 삭제
	DELETE FROM DEPARTMENT2
	WHERE DEPT_ID LIKE 'T%';

	ROLLBACK TO "SP1";
	SELECT * FROM DEPARTMENT2;
	