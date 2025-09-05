/*
        DML (DATA MAINPULATION LANGUAGE): 데이터 조작어
            테이블의 값을 검색(select), 삽입(insert), 수정(update), 삭제(delete)
*/
---------------------------------------------------------------------------------------------------
/*
        1. insert 
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
        2. INSERT INTO 테이블명 (컬럼명, 컬럼명, ...) VALUES (값, 값, ...)
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
        3. insert into 테이블명 (서브쿼리);
            values로 값을 직접 명시하는 대신 서브쿼리로 조회된 결과값을 모두 insert (여러행 insert 가능)
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
        4. insert all 
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
        5. 조건을 사용하여 insert 가능
        
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


