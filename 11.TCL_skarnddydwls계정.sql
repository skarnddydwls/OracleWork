/*
        < TCL: Transaction Control Language>
            트랜잭션 제어 언어
            
        * 트랜젝션 
            - 데이터베이스의 논리적 연산 단위
            - 데이터의 변경 사항(DML)들을 하나의 트랜잭션에 묶어서 처리
                DML문 한 개를 수행할 때 트랜잭션이 존재하면 해당 트랜잭션에 같이 묶어서 처리
                                                      트랜잭션이 없다면 트랜잭션을 만들어서 묶어서 처리
                COMMIT하기전까지의 변경사항을 하나의 트랜잭션에 담게 됨
            - 트랜잭션의 대상이 되는 SQL: INSERT, UPDATE, DELETE
                
        >> commit: 트랜잭션 종료 처리 후 확정
                            한 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영시키겠다는 의미 (그 후에 트랜잭
        >> rollback: 트랜잭션 취소 
                            한 트랜잭션에 담겨있는 변경사항들을 삭제(취소) 한 후 마지막 commit 지점으로 돌아감
        >> savepoint: 임시저장
                             현재 시점에 해당 포인트명으로 임시저장점을 정의해두는 것
                             ROLLBACK 진행 시 전체 변경사항들을 다 삭제하는 것이 아니라 일부만 롤백 가능
*/

-- 사번이 301번인 사원 지우기
delete from emp_01
where emp_id = 301;

-- 사번이 218번인 사원 지우기
delete from emp_01
where emp_id = 218;

rollback; -- 트랜잭션에 들어있던 301번과 218번의 삭제가 취소 됨 (트랜잭션이 사라짐)
----------------------------------------------------------------------------------
-- 사번 200번 사원 지우기
delete from emp_01
where emp_id = 200;

select * from emp_01 order by emp_id;

insert into emp_01
values (400, '남궁용진', '총무부');

commit;

rollback;

----------------------------------------------------------------------------------
-- 217, 216, 214 사원 지우기
delete from emp_01
where emp_id in (217,216,214);

savepoint sibal;

select *
from emp_01
order by emp_id;

insert into emp_01
values(401, '박근혜', '전대통령');

rollback to sibal;

commit;

/*
        자동 commit이 되는 경우
            - 정상 종료
            - DCL과 DDL 명령문이 수행된 경우
            
        자동 rollback이 되는 경우
            - 비정상 종료
            - 전원이 꺼짐, 정전, 컴퓨터 down
*/
-- 사번이 301, 400 지우기
delete from emp_01
where emp_id in (301, 400);

--DDL 문
create table test (
    t_id number
);

rollback; --DDL문이 수행되었기에 남은 트랜잭션이 없음

select *
from emp_01
order by emp_id;