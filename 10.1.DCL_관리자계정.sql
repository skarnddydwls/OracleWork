/*
        <DCL: DATA CONTROL LANGUAGE>
        데이터 제어 언어
        
        * 계정에 시스템 권한 또는 객체 접근 권한등을 부여 (grant)하거나 회수 (revoke)하는 구문
            > 시스템 권한: DB에 접근하는 권한, 객체를 생성할 수 있는 권한
            > 객체 접근 권한: 특정 객체를 조작할 수 있는 권한 
            
        * 시스템 권한의 종류
            - create session: 접속할 수 있는 권한
            - create table: 테이블을 생성할 수 있는 권한
            - create view: 뷰를 생성할 수 있는 권한
            - create sequence: 시퀀스를 생성할 수 있는 권한
                ...
*/
-- 1. sample 계정 생성
ALTER session set "_oracle_script" = true;
create user sample identified by 1234;
-- 접속시 오류 (접속권한 없음)

-- 2. 접속권한 부여
grant create session to sample;
-- sample에 접속하여 테이블 생성시 오류

-- 3. 테이블 생성 권한 부여 
grant create table to sample;
-- sample계정에서 테이블은 생성되지만, insert는 안됨

-- 4. tablespace 할당
alter user sample quota unlimited on users;
-- OR
alter user sample quota 5M on users;

---------------------------------------------------------------------------------
/*
        객체 접근 권한 종류
            특정 객체에 접근할 수 있는 권한
            
            권한 종류
                select      table, view, sequence
                insert      table, view
                update     table, view
                delete      table, view
                ...
                
            [표현식]
            grant 권한종류 on 특정객체 to 계정명;
                - grant 권한종류 on 권한을 가지고 있는 user, 특정객체 to 권한을 줄 user;
*/
-- sample 계정에게 skarnddydwls 계정의 employee 테이블을 select 할 수 있는 권한
grant select on skarnddydwls.employee to sample;

-- sample 계정에게 skarnddydwls 계정의 department 테이블에 insert할 수 있는 권한
grant insert on skarnddydwls.department to sample;

grant select on skarnddydwls.department to sample;

---------------------------------------------------------------------------------
/*
        권환 회수
            revoke 회수할권한 on from 계정명;
*/
revoke select on skarnddydwls.employee from sample;
revoke select on skarnddydwls.department from sample;
revoke insert on skarnddydwls.department from sample;

---------------------------------------------------------------------------------
/*
        <ROLE>
            특정 권한들을 하나의 집합으로 모아놓은 것
            
        CONNECT: CREATE, SESSION
        RESOURCE: CREATE TABLE, CREATE VIEW, CREATE SEQUENCE ...
        DBA: 시스템 및 객체 관리에 대한 모든 권한을 갖고 있는 롤
        
        - 23ai 버전에서 신규 롤 추가
        DB_DEVELOPER_ROLE: CONNECT + RESOURCE + 기타 개발 관련 권한까지 포함
        
        [표현식]
        GRANT CONNECT, RESOURCE TO 계정명;
        GRANT DB_DEVELOPER_ROLE TO 계정명;
*/

create user test identified by 1234;
grant db_developer_role to test;

alter user test quota unlimited on users;

-- 테이블 role_sys_privs에 role이 정의되어 있음
select * from role_sys_privs;

select *
from role_sys_privs
where role in ('CONNECT', 'RESOURCE')
order by 1;











