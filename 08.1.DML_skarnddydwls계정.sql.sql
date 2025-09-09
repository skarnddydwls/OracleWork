/*
        DML (DATA MAINPULATION LANGUAGE): 데이터 조작어
            테이블의 값을 검색(select), 삽입(insert), 수정(update), 삭제(delete)
*/
---------------------------------------------------------------------------------------------------
/*
        1-1. insert 
            테이블에 새로운 행을 추가하는 구문
            
            [표현식]
            1) insert into 테이블명 values(값1, 값2, 값3, ... );
                테이블에 모든 컬럼에 대한 값을 직접 넣어 한 행을 넣고자 할 때 사용
                컬럼 순서를 지켜 values에 값을 나열해야 함
                
                부족하게 값을 넣었을 때 => not enough value 오류
                값을 더 많이 넣었을 때 => too many value 오류
*/

insert into employee values (300, '이하늘', '020412-1234567', 'elelte991@tukorea.ac.kr', 
                                                '01099748286', 'D2', 'J5',3500000, 0.15, 200, sysdate, null, default);
                                                
---------------------------------------------------------------------------------------------------
/*
        1-2. INSERT INTO 테이블명 (컬럼명, 컬럼명, ...) VALUES (값, 값, ...)
            테이블에 내가 선택한 컬럼에 대한 값만 INSERT할 때 사용
            그래도 한 행단위로 추가되기 때문에 선택이 안된 컬럼은 기본적으로 NULL이 들어감
            단, 기본값(DEFAULT)이 지정되어 있으면 NULL이 아닌 기본값이 들어감
            => NOT NULL 제약조건이 걸려있는 컬럼은 반드시 선택해서 데이터를 넣어줘야 함
*/

insert into employee (emp_id, emp_name, emp_no, job_code) values (301, '최다니엘', '961125-1134768', 'J3');  

insert
    into employee
            ( 
                emp_id,
                emp_name,
                emp_no,
                job_code,
                hire_date
            )
    values
            (
                302,
                '강이찬',
                '990719-1135124',
                'J4',
                sysdate
            );
            
        
---------------------------------------------------------------------------------------------------
/*
        1-3 values로 값을 직접 명시하는 대신 서브쿼리로 조회된 결과값을 모두 insert (여러행 insert 가능)
*/
-- 테이블 생성

create table emp_01 (
    emp_id number,
    emp_name varchar2(20),
    dept_name varchar2(35)
);
-- 전체 사원들의 사번, 이름, 부서명을 조회하여 테이블에 넣기

select emp_id, emp_name, dept_title
from employee
left join department on (dept_code = dept_id);

insert into emp_01
    (select emp_id, emp_name, dept_title
        from employee
        left join department on (dept_code = dept_id)
    );

---------------------------------------------------------------------------------------------------
/*
        1-4. insert all 
            두 개 이상의 테이블에 각각 insert할 때
            이때 사용되는 서브쿼리가 동일한 경우 
            
            [표현식]
             insert all
             into 테이블명1 values(컬럼명, 컬럼명, ...)
             into 테이블명2 values(컬럼명, 컬럼명, ...)
                서브쿼리;
*/
-- 테스트할 테이블 두 개 생성

create table emp_dept
as select emp_id, emp_name, dept_code, hire_date
    from employee
    where 1=0;
    
create table emp_manager
as select emp_id, emp_name, manager_id
    from employee
    where 1=0;
    
-- 부서코드가 D1인 사원들의 사번, 이름, 부서코드, 입사일, 사수번호 조회
select emp_id, emp_name, dept_code, hire_date, manager_id
from employee
where dept_code = 'D1';

insert all
    into emp_dept values (emp_id, emp_name, dept_code, hire_date)
    into emp_manager values (emp_id, emp_name, manager_id)
    select emp_id, emp_name, dept_code, hire_date, manager_id
    from employee
    where dept_code = 'D1';


---------------------------------------------------------------------------------------------------
/*
        1-5. 조건을 사용하여 insert 가능
        
        [표현식]
        insert all
        when 조건 then
                into 테이블명1 values (컬럼명, 컬럼명, ...)
        when 조건 then
                into 테이블명2 values (컬럼명, 컬럼명, ...)
        서브쿼리;
*/
-- 2000년도 이전에 입사한 직원들을 담을 테이블 생성
create table emp_old
as select emp_id, emp_name, hire_date, salary
     from employee
     where 1=0;

-- 2000년도 이후에 입사한 직원들을 담을 테이블 생성
create table emp_new
as select emp_id, emp_name, hire_date, salary
     from employee
     where 1=0;
     
insert all
when hire_date < '2000/01/01' then
        into emp_old values (emp_id, emp_name, hire_date, salary)
when hire_date >= '2000/01/01' then
        into emp_new values (emp_id, emp_name, hire_date, salary)
select emp_id, emp_name, hire_date, salary
from employee;


---------------------------------------------------------------------------------------------------
/*
        2-1. UPDATE
            테이블에 기록되어 있는 기존의 데이터를 수정하는 구문
            
            [표현식]
            UPDATE 테이블명
            SET 컬럼명 = 바꿀값,
                    컬럼명 = 바꿀값,
                    ...
            [WHERE 조건];  => 주의: 조건을 생략하면 전체 모든 행의 데이터가 변경됨
*/
-- department 테이블 복사본 만들기 (데이터까지)
create table dept_copy
as select* from department;

-- D9 부서의 부서명을 '전략기획팀'으로 변경
update dept_copy 
set dept_title = '전략기획부'; -- where절이 없으면 전체다 변경됨

rollback; -- 되돌리기

update dept_copy 
set dept_title = '전략기획부'
where dept_id = 'D9'; 

-- employee 테이블 복사본 컬럼은 emp_id, emp_name, salary, bonus
create table employee_copy
as select emp_id, emp_name, salary, bonus from employee;

-- 박정보 사원의 급여를 400 만원으로 변경
update employee_copy
set salary = 4000000
where emp_id = 202;
--where emp_name = '박정보'; -- 같은 이름이 있을 수 있어서 id(기본 키)를 사용하는게 좋음

-- 김정보 사원의 급여를 700만원으로, 보너스를 0.2로 변경
update employee_copy
set salary = 7000000, bonus = 0.2
where emp_name = '김정보'; -- 마찬가지로 id로 하는게 좋음

-- 전체 사원의 급여를 기존급여에 10% 인상한 금액으로 변경
update employee_copy
set salary = salary * 1.1;
---------------------------------------------------------------------------------------------------
/*
        2-2. UPDATE시 서브쿼리 사용 가능
            UPDATE 테이블명
            SET 컬럼명 = (서브쿼리)
            [WHERE 조건];
*/
-- 왕정보 사원의 급여와 보너스를 장정보 사원의 급여와 보너스와 동일하게 변경
update employee_copy
set salary = (select salary from employee_copy where emp_name = '장정보'), 
      bonus = (select bonus from employee_copy where emp_name = '장정보')
where emp_name = '왕정보';

-- 다중열 서브쿼리로도 가능
update employee_copy
set (salary, bonus) = (select salary, bonus from employee_copy where emp_name = '장정보')
where emp_name = '김정보';

rollback;

-- 홍정보, 최하보, 문정보, 이하늘, 강정보 사원의 급여와 보너스를 유하보 사원의 것과 같게 변경
update employee_copy
set (salary, bonus) = (select salary, bonus from employee_copy where emp_name ='유하보')
where emp_name in ('홍정보', '최하보', '문정보', '이하늘', '강정보');

-- asia 지역에서 근무하는 사원들의 bonus를 0.3으로 변경
-- 서브쿼리
select emp_id
from employee_copy
join department on (dept_code = dept_id)
join location on (location_id = local_code)
where local_name like 'ASIA%';

update employee_copy
set bonus = 0.3
where emp_id in -- '='로 하면 안 됨 (여러개라서)
(select emp_id
from employee_copy
join department on (dept_code = dept_id)
join location on (location_id = local_code)
where local_name like 'ASIA%'); 

drop table employee_copy;

create table employee_copy
as select emp_id, emp_name, dept_code, salary, bonus from employee;

---------------------------------------------------------------------------------------------------
-- update시에도 제약조건에 위배되면 안됨
-- 사번이 200인 사원의 이름을 null
update employee
set emp_name = null
where emp_id = 200; --> not null 위배

-- department 테이블의 dept_id가 D9인 부서의 location_id를 L7 변경
update department
set location_id = 'L7'
where dept_id = 'D9'; --> foreign key 위배 난 왜 됨?

---------------------------------------------------------------------------------------------------
/*
        3. DELETE
            테이블에 기록된 데이터를 삭제하는 구문 (행 단위로 삭제됨)
            
            [표현식]
            DELETE FROM 테이블 
            [WHERE 조건식];  --> where절이 없으면 전체 행 삭제 
            
            ** 삭제시엔 반드시 넣어줘야 됨 **
*/
--  오정보 사원의 데이터를 삭제
delete from employee
where emp_name = '오정보';

rollback;
commit;

-- department 테이블에서 dept_id가 D1인 부서 삭제
delete from department
where dept_id = 'D1';

---------------------------------------------------------------------------------------------------
/*
        TRUNCATE: 테이블의 전체 행을 삭제할 때 사용되는 구문
            - DELETE보다 수행 속도가 빠름
            - 별도의 조건 제시 불가, ROLLBACK도 불가
        
        TRUNCATE TABLE 테이블명;
*/
truncate table employee_copy;
rollback; -- truncate로 삭제한것은 rollback해도 돌아오지 않음

