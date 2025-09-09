/*
    < VIEW >
    SELECT문을 저장해둘 수 있는 객체
    (자주 쓰는 긴 SELECT문을 저장해두면 매번 긴 SELECT문을 다시 기술할 필요 없음)
    임시테이블 같은 존재(실제 데이터가 담겨있는거 아님 => 논리적인 테이블)
*/
-- '한국'에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING (NATIONAL_CODE)
 WHERE NATIONAL_NAME = '한국'; 
  
-- '러시아'에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명 조회  
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING (NATIONAL_CODE)
 WHERE NATIONAL_NAME = '러시아';   

-- '일본'에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명 조회 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING (NATIONAL_CODE)
 WHERE NATIONAL_NAME = '일본';    
  
--------------------------------------------------------------------------------
/*
    1. VIEW 생성 방법
    
    [표현법]
    CREATE VIEW 뷰명
    AS 서브쿼리;
*/
CREATE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
     FROM EMPLOYEE
     JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
     JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
     JOIN NATIONAL USING (NATIONAL_CODE);

-- == 아래와 같은 맥락
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
         FROM EMPLOYEE
         JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
         JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
         JOIN NATIONAL USING (NATIONAL_CODE));

-- 한국, 러시아, 일본에서 근무하는 사원
SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '한국';

SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '러시아';

SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '일본';
 
--------------------------------------------------------------------------------
/*
    * 뷰 컬럼에 별칭 부여
      서브쿼리의 SELECT절에 함수식이나 산술연산식이 기술되어있는 경우에는 반드시 별칭 부여
*/
-- 전 사원의 사번, 사원명, 직급명, 성별(남/여), 근무년수를 조회할 수 있는 SELECT문을 뷰(VW_EMP_JOB)로 정의
-- CREATE OR REPLACE VIEW 뷰명  => 같은 이름 뷰가 존재하면 뷰를 갱신(덮어쓰기), 뷰가 없으면 생성
CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1','남','2','여','3','남','여'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
     FROM EMPLOYEE
     JOIN JOB USING(JOB_CODE);
-- 오류 : 열의 별명과 함께 지정해야 합니다 

CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1','남','2','여','3','남','여') 성별,
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
     FROM EMPLOYEE
     JOIN JOB USING(JOB_CODE);
 
-- 아래와 같은 방식으로도 별칭 부여 가능 
CREATE OR REPLACE VIEW VW_EMP_JOB(사번, 사원명, 직급명, 성별, 근무년수) 
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1','남','2','여','3','남','여'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
     FROM EMPLOYEE
     JOIN JOB USING(JOB_CODE);
     
-- 여성 사원의 사원명, 직급명 조회
SELECT 사원명, 직급명
  FROM VW_EMP_JOB
 WHERE 성별 = '여';
 
-- 근무년수가 20년 이상인 사원의 모든 컬럼 조회
SELECT *
  FROM VW_EMP_JOB
 WHERE 근무년수 >= 20; 

-----------------------------------------------------------------------------
/*
        뷰 삭제
            DROP VIEW 뷰명;
*/
drop view vw_emp_jop;

-----------------------------------------------------------------------------
/*
        VIEW에서 DML 사용가능
            생성된 뷰를 이용하여 DML(INSERT, UPDATE, DELETE) 사용 가능
            뷰를 통해서 조각하게 되면 실제 데이터가 담겨있는 데이터 테이블에 반영됨
*/ 
create or replace view vw_job
as select job_code, job_name
from job;

-- 뷰를 통해서 insert
insert into vw_job values ('J8', '인턴');

-- 뷰를 통해서 update
update vw_job
set job_name = '알바'
where job_code = 'J8';

-- 뷰를 통해서 delete
delete from vw_job
where job_code = 'J8';

/*
        DML 명령어 조작이 불가능한 경우가 더 많음
            1) 뷰에 정의되지 않은 컬럼을 조작하려고 할 때 
            2) 뷰에 정의되지 않은 컬럼중에 베이스테이블 상에 not null 제약조건이 지정되어 있는 경우
            3) 산술연산식 또는 함수식이 정의되어 있는 경우
            4) 그룹함수나 group by절이 포함된 경우
            5) distinct 구문이 포함된 경우
            6) join을 이용하여 여러 테이블을 연결시켜 놓은 경우
*/
-- 1) 뷰에 정의되지 않은 컬럼을 조작하려 할 때
create or replace view vw_job
as select job_code
from job;

-- insert 하기 (오류)
insert into vw_job(job_code, job_name) values ('J8', '인턴'); -- job_name이 존재하지 않음

-- update (오류)
update vw_job
set job_name = '인턴' -- job_name이 존재하지 않음
where job_code = 'J7';

-- delete (오류)
delete
from vw_job
where job_name = '사원';

-- 2) 뷰에 정의되지 않은 컬럼중에 베이스테이블 상에 not null 제약조건이 지정되어 있는 경우
create or replace view vw_job
as select job_name
from job;

-- insert (오류)
insert into vw_job values('인턴'); -- 이렇게 넣으면 실제 job_code(primary key)에 null 값이 들어가기에 오류

-- update
update vw_job
set job_name = '알바'
where job_name = '사원'; -- 둘 다 정의되어 있어서 오류나지 않음

-- delete (성공일수도 오류일수도 있음. 외래키가 걸려있어 자식테이블에서 값을 
delete from vw_job
where job_name = '대리';

-- 3) 산술연산식 또는 함수식이 정의되어 있는 경우
create view vw_emp_sal
as select emp_id, emp_name, salary, salary*12 연봉 
from employee;

-- insert 오류: 베이스테이블에는 연봉이라는게 없음
insert into vw_emp_sal values(400,'김상진',3000000); 

--update 오류: 연봉이 베이스테이블에 없음
update vw_emp_sal
set 연봉 = 45000000
where emp_id = 300;

-- 301번 사원의 급여를 250만원으로 변경
update vw_emp_sal
set salary = 2500000
where emp_id = 301;

-- delete
delete from vw_emp_sal
where 연봉 = 72000000;

rollback;

-- 4) 그룹함수나 group by절이 포함된 경우
create view vw_group_dept
as select dept_code, sum(salary) 합계, round(avg(salary)) 평균 -- round: 반올림
from employee
group by dept_code;

-- insert 오류: 합계와 평균은 가상 열이라 사용 불가
insert into vw_group_dept values ('D3', 8000000, 4000000);

-- update 오류: D1인 사람들 중 누구의 급여를 올릴지 알 수 없음
update vw_group_dept
set 합계 = 8000000
where dept_code = 'D1';

select emp_id, dept_code, salary
from employee
where dept_code = 'D1';

-- delete 오류
delete from vw_group_dept
where 합계 = 5210000;

-- delete 오류
delete from vw_group_dept
where dept_code is null; -- dept_code = null  << 이건 안됨(문법 오류)

-- 5) distinct 구문이 포함된 경우
create view vw_di_job
as select distinct job_code
from employee;

-- insert 오류
insert into vw_di_job values('J8');

-- update 오류: J7에 여러개 있어서 오류
update vw_di_job
set job_code = 'J8'
where job_code = 'J7';

-- delete 오류: 데이터가 여러개 있어서 이것도 오류
delete from vw_di_job
where job_code = 'J4';

-- 6) join을 이용하여 여러 테이블을 연결시켜 놓은 경우
create view vw_join
as select emp_id, emp_name, dept_title
from employee
join department on (dept_code = dept_id);

-- insert (오류)
insert into vw_join values(300, '황미혜', '총무부');

-- update 
update vw_join
set emp_name = '김새로'
where emp_id = 300;

-- update 성공 (그러나 조인을 통해 부서를 가져왔기 때문에 employee 테이블의 dept_code는 수정이 안됨)
update vw_join
set dept_title = '인사관리부'
where emp_id =200; -- 왜 다바뀜?

-- delete
delete from vw_join
where emp_id = 200;

-----------------------------------------------------------------------------
/*  
        VIEW 옵션
            [상세표현식] CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰명
            AS 서브쿼리
            [WITH CHECK OPTION]
            [WITH READ ONLY]
            
            1) OR REPLACE: 기존에 동일한 뷰가 있으면 갱신하고, 없으면 새로 생성
            2) FORCE | NOFORCE
                > FORCE: 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰를 생성함
                > NOFORCE: 서브쿼리에 기술된 테이블이 존재해야만 뷰가 생성됨(생략시 기본값)
            3) WITH CHECK OPTION: DML시 서브쿼리에 기술된 조건에 부합한 값으로만 DML 가능하도록 함
            4) WITH READ ONLY: 뷰에 대해 조회만 가능(DML문 수행불가)
*/
-- 2) force | noforce
-- noforce
create /*noforce*/ view vw_emp
as select tcode, tname, tcontent
from tt; -- tt 테이블이 없기 때문에 오류

create force view vw_emp
as select tcode, tname, tcontent
from tt; -- view 생성 가능

-- vw_emp view를 사용하려면 tt테이블을 생성해야만 사용가능함
create table tt(
    tcode number,
    tname varchar2(20),
    tcontent varchar2(100)
);

insert into vw_emp values (1, '남궁용진', '내용삽입');

select * from vw_emp; -- 베이스테이블 생성후엔 select 가능

-- 3) with check option
-- with check option을 사용 안 하고
create or replace view vw_emp
as select * from employee
where salary >= 3000000;

select * from vw_emp; -- 8명

-- 300번 사원의 급여를 200으로 변경
update vw_emp
set salary =2000000 --300만원 이상만 데려오는 뷰였는데 200으로 수정되어서 뷰에서 빠짐
where emp_id =300; 

select * from vw_emp; -- 7명

-- with check option을 사용
create or replace view vw_emp
as select* from employee
where salary >= 3000000
with check option;

update vw_emp
set salary = 2000000
where emp_id = 217; -- 오류

update vw_emp
set salary = 4000000
where emp_id = 217; -- 성공

rollback;

-- 4) with read only
create or replace view vw_emp
as select emp_id, emp_name, bonus
from employee
where bonus is not null
with read only;

select * from vw_emp;
select * from vw_emp where bonus >= 0.2;

update vw_emp
set bonus = 0.35
where emp_id = 200;     -- 오류

delete from vw_emp
where emp_id = 200;     -- 오류