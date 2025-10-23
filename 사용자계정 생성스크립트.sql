-- "--" : DB 에서 한 줄 주석
/*
 * 범위주석
 */
-- SELECT * FROM ALL_USERS;
-- SQL(Stuructured Query Language, 구조적 질의 언어)
 -- 데이터베이스와 상호작용을 하기 위해 사용하는 표준 언어
 -- 데이터의 조회, 삽입, 수정 삭제 명령 등을 수행할 수 있다

-- 데이터베이스는 기본적으로 대문자로 작성

-- 선택한 SQL 수행 : 구문에 커서를 두고, CTRL + ENTER
-- 전체 SQL 수행 : 해당 스크립트에 있는 모든 SQL 수행 : ALT + X

-- SYS 라는 최고관리자 계정으로 모든 것을 하지 않는다.
 -- 권한 부여, 새 DB 의 객체 생성 등..
 -- 실제로 업무를 할 때는 SYS 가 부여한 사용자 계정으로 업무를 하게 된다

-- ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; 
-- 11G 이전 문법 사용 허용

-- 새로운 사용자 계정 생성
CREATE USER c##sjh IDENTIFIED BY sjh1234;
-- > 계정 생성 구문 ( 계정명 : KH_SJH, 패스워드 : KH1234 )
-- > 이대로 수행 시 에러 발생 ( SQL Error [1920] [42000]: ORA-01920: 사용자명 'KH_SJH'(이)가 다른 사용자나 롤 이름과 상충됩니다 )

GRANT RESOURCE, CONNECT TO c##sjh;
-- 사용자 계정에 권한 부여 설정
 -- RESOURCE : 테이블이나 인덱스 같은 DB 의 객체를 생성할 권한
 -- CONNECT : DB 에 연결하고 로그인할 수 있는 권한

ALTER USER c##sjh DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;
-- 객체가 생성될 수 있는 공간 할당량 무제한 지정
