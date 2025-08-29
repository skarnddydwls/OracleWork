/*
    *DML: 데이터 조작어
    테이블에 값을 검색(SELECT), 삽입(INSERT), 수정(UPDATE), 삭제(DELETE)하는 구문
     - select, insert, update, delete
     
================================================================================
    (')홑따옴표: 문자열을 감싸주는 기호
    (")쌍따옴표: 컬럼명등을 감싸주는 기호
    
================================================================================
    <SELECT>
    데이터를 조회할 때 사용한느 구문
    
    >> RESULT SET: select문을 통해 조회된 결과물(조회된 행들의 집합)
    
    [표현법]
    select 컬럼명, 컬럼명...
    from 테이블명;
*/
-- EMPLOYEE 테이블의 모든 컬럼(*)
select *
from employee;

-- employee 테이블에서 사번, 이름, 급여만 조회
select emp_id, emp_name, salary
from employee;

-- jop 테이블의 모든 컬럼 조회
select *
from job;

--1. job 테이블의 직급명만 조회
select job_name
from job;

--2. department 테이블의 모든 컬럼 조회
select *
from department;

--3. department 테이블의 부서코드, 부서명 조회
select dept_id, dept_title
from department;

--4. employee 테이블에 사원명, 이메일, 전화번호, 입사일, 급여 조회
select emp_name, email, phone, hire_date, salary
from employee;

/*
    <컬럼값을 통한 산술 연산>
    select절 컬럼명 작성하는 부분에 산술연산을 기술
*/

-- employee 테이블에서 사원명, 연봉(급여*12) 조회
select emp_name, salary*12
from employee;

-- employee 테이블에서 사원명, 급여, 보너스 조회
select emp_name, salary, bonus
from employee;

-- employ 테이블에서 사원명, 급여, 보너스, 연봉, 보너스가 포함된 연봉
select emp_name, salary, bonus, salary*12 , salary*bonus+salary*12
from employee;

-- date끼리도 연산 가능: 결과값은 일 단위
-- 오늘 날짜: sysdate

-- employee 테이블에서 사원명, 입사일, 근무일수(오늘날짜-입사일)
select emp_name, hire_date, sysdate-hire_date 
from employee;
/*
================================================================================

    <컬럼명에 별칭 지정하기>
    - 산술연산시 컬럼명이 산술에 들어간 수식 그대로 됨
    - 별칭으로 컬렴명을 바꿔줄 때
    
    [표현법]
    1. 컬럼명 별칭
    2. 컬럼명 as 별칭
    3. 컬럼명 "별칭"
    4. 컬럼명 as "별칭"
    
    ** 반드시 별칭에 쌍따옴표(" ")가 들어가야 하는 경우
        : 별칭에 띄어쓰기, 특수기호가 들어간 경우
*/

-- employ 테이블에서 사원명, 급여, 보너스, 연봉, 보너스가 포함된 연봉
select emp_name, salary, bonus, salary*12 연봉, salary*bonus+salary*12 "총 소득"
from employee;

select emp_name, salary, bonus, salary*12 "연봉(원)", salary*bonus+salary*12 "총 소득"
from employee;
-- 별칭 앞에 as는 넣어도 되고 안 넣어도 됨
/*
================================================================================

    <리터럴>
    임의로 지정한 문자열(' ')
    
    select절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터처럼 조회 가능 
    조회된 result set의 모든 행에 반복적으로 출력
*/
-- employee 테이블에서 사번, 사원명, 급여, 원 조회
select emp_id, emp_name, salary, '원' as 단위
from employee;

/*
================================================================================

    <연결 연산자: ||>
    여러 컬럼값들을 마치 하나의 컬럼인것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있음
*/
-- employee 테이블에서 사번 이름, 급여를 하나의 컬럼으로 조회
select emp_id || emp_name || salary
from employee;

-- 컬럼값과 리터럴 연결
select emp_name || '의 월급은 ' || salary || ' 입니다.'
from employee;

/*
================================================================================

    <distinct>
    컬럼의 중복된 값들을 한 번씩만 표시하고자 할 때 
*/
-- employee 테이블에서 직급 코드 조회
select job_code
from employee;

select distinct job_code
from employee;

-- employee 테이블에서 부서코드 중복 제거 조회
select  distinct dept_code
from  employee;

-- 유의사항: distinct는 select절에서 딱 한 번만 기술 가능

/*
    <where 절>
    조회하고자 하는 테이블로부터 특정 조건에 만족하는 데이터만 조회할 때
    이때 where절에 조건을을 제시하면 됨
    조건식에는 다양한 연산자 사용 가능
    
    [표현법]
    select 컬럼명, 컬렴명, 산술연산...
    from 테이블명
    where 조건식;
    
    >> 조건식에는 비교연산자 사용가능
    대소 비교: >, <, >=, <=
    같은지 비교: =
    같지않은지 비교: !=, ^=, <>
*/
-- employee 테이블에서 부서코드가 'D9'인 사원들의 모든 컬럼 조회
select *
from employee
where dept_code = 'D9';

-- employee 테이블에서 부서코드가 'D1'이 아닌 사원들의 사번, 사원명, 부서코드
select emp_id, emp_name, dept_code
from employee
where dept_code != 'D1';

-- employee 테이블에서 급여가 400만원 이상인 사원의 사원명, 부서코드, 급여 조회
select emp_name, dept_code, salary
from employee
where salary >= 4000000;

-- employee 테이블에서 재직중인 사원의 사번, 이름, 입사일 조회
select emp_id, emp_name, hire_date,ent_yn
from employee
where ent_yn = 'N';

--1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉 조회
select emp_name, salary, hire_date, salary*12 연봉
from employee
where salary >= 3000000;

--2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회
select emp_name, salary, salary*12 연봉, dept_code
from employee
where salary*12 >= 50000000;

--3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, 퇴사여부 조회
select emp_id, emp_name, job_code, ent_yn
from employee
where job_code != 'J3';

/*
    <논리 연산자>
    여러개의 조건을 제시하고자 할 때 사용
    
    AND (~이면서, 그리고)
    OR (~이거나, 또는)
*/   
-- employee 테이블에서 부서코드가 'D9'이면서 급여가 500만원 이상인 사원들의 사원명, 부서코드, 급여조회
select emp_name, dept_code, salary
from employee
where dept_code = 'D9' and salary >= 5000000;

-- employee 테이블에서 부서코드가 'D6'이거나 급여가 300만원 이상인 사원들의 사원명, 부서코드, 급여조회
select emp_name, dept_code, salary
from employee
where dept_code='D6' or salary >= 3000000;

-- employee테이블에서 급여가 350만원 이상 600만원 이하인 사원들의 사번, 사원명, 급여 조회
select emp_id, emp_name, salary
from employee
where salary >= 3500000 and salary <= 6000000;
    
/* 
    <between and>
    조건식에서 사용되는 구문
    ~이상 ~이하인 범위에 대한 조건을 제시할 때 사용되는 연산자
    
    [표현법]
    비교대상 컬럼 between 하한값 and 상한값
     => 해당 컬럼값이 하한값 이상이고 상한값 이하인 경우 조회
*/
-- employee테이블에서 급여가 350만원 이상 600만원 이하인 사원들의 사번, 사원명, 급여 조회
select emp_id, emp_name, salary
from employee
where salary between 3500000 and 6000000;

-- 위와 반대인 상황
select emp_id, emp_name, salary
from employee
where salary < 3500000 or salary > 6000000;

-- 위를 between으로 
select emp_id, emp_name, salary
from employee
where not salary BETWEEN 3500000 and 6000000;

-- not: 논리부정연산자
--          컬럼명 앞 또는 betweeen 앞에 기입 가능

-- employee에서 입사일이 90/01/01 ~ 01/01/01 인 사원의 모든 컬럼 조회
select *
from employee
where hire_date  >= '90/01/01' and hire_date <= '01/01/01';

/*
    
    <Like>
    비교하고자하는 컬럼값이 내가 제시한 특정 패턴에 만족하는 경우
    
    [표현법]
    비교대상 컬럼 like '특정패턴'
    
    '%': 0글자 이상 
        ex) 비교대상컬럼 link '문자%' => 비교대상컬럼이 '문자'로 시작하는 값 조회
        ex) 비교대상컬럼 link '%문자' => 비교대상컬럼이 '문자'로 끝나는 값 조회
        ex) 비교대상컬럼 link '문자%' => 비교대상컬럼이 '문자'를 포함하는 값 조회
        
    '_' : 1개당 1글자
        ex) like '_문자' -> 비교대상컬럼값이 '문자'앞에 무조건 한 글자가 있고 문자로 끝나는 값 조회
              like '_ _문자' -> 비교대상컬럼값이 '문자'앞에 무조건 두 글자가 있고 문자로 끝나는 값 조회
              like '_문자_' -> 비교대상컬럼값이 '문자' 앞과 끝에 한 글자가 있고 중간에 문자가 있는 값 조회
*/
-- employee 테이블에서 사원명 중 전씨인 사원들의 사원명, 급여, 입사일 조회
select emp_name, salary, hire_date
from employee
where emp_name like '전%';

-- employee 테이블에서 사원명에서 '하'가 포함되어 있는 사원들의 사원명, 전화번호 조회
select emp_name, phone
from employee
where emp_name like '%하%';

-- employee 테이블에서 전화번호의 3번째 자리가 1인 사원들의 사번, 전화번호 조회
select emp_name, phone
from employee
where phone like '__1%';

-- 이메일 중 _(언더바) 앞에 3글자인 사원들의 이름, 이메일
select  emp_name, email
from employee
where email like '____%'; -- 언더바 4개
/* - 와일드카드로 사용되고 있는 문자와 컬럼값에 들어있는 문자가 동일하기 때문에 조회 안됨
    - 모두 와일드카드로 인식
    - 어떤것이 와일드카드이고 데이터값인지 구분지어야 함
    - 데이터값으로 취급하고자하는 값 앞에 나만의 와일드카드(문자, 숫자, 특수기호 ...)를 제시하고,
        나만의 와일드카드를 escape로 등록
    - 특수기호중 '&'는 오라클에서 사용자로부터 입력받는 키워드이므로 안 쓰는게 좋음
*/

select  emp_name, email
from employee
where email like '___$_%' escape '$'; -- $뒤는 컬럼값을 의미

-- 위의 사원을 제외한 사원들 조회

select  emp_name, email
from employee
where not email like '___$_%' escape '$';

-- 1. employee 에서 이름이 '연'으로 끝나는 사원들의 사원명, 입사일 조회
select emp_name, hire_date
from employee
where emp_name like '%연';

-- 2. employee에서 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
select emp_name, phone
from employee
where not phone like '010%';

-- 3. employee에서 이름에 '하'가 포함되어 있고 급여가 240만원 이상인 사람들의 사원명, 급여 조회
select emp_name, salary
from employee
where emp_name like '%하%' and salary >= 2400000;

-- 4. department에서 해외영업부인 부서들의 부서코드, 부서명 조회
select dept_id, dept_title
from department
where dept_title like '해외영업%';

/*
================================================================================
    
    <is null / is not null>
    컬럼값이 null인 경우 null값 비교에 사용되는 연산자
*/
-- employee 테이블에서 보너스를 받지 않는 사원들의 사번, 사원명, 급여, 보너스 조회
select emp_id, emp_name, salary, bonus
from employee
where bonus is null;

-- employee 테이블에서 보너스를 받지 않는 사원들의 사번, 사원명, 급여, 보너스 조회
select emp_id, emp_name, salary, bonus
from employee
where bonus is not null;

-- employee 테이블에서 사수가 없는 사원들의 사원명, 부서코드 조회
select emp_name, dept_code, manager_id
from employee
where manager_id is null;

-- employee 테이블에서 부서 배치를 받지 않았지만 보너스는 받는 사원들의 사원명, 보너스, 부서코드 조회
select emp_name, bonus, dept_code
from employee
where dept_code is null and bonus is not null;

/*
================================================================================
    
    <in / not in>
    in: 컬럼값이 내가 제시한 목록들중에서 일치하는 값이 있는것만 조회
    not in: 컬럼값이 내가 제시한 목록들중에서 일치하는 값을 제외한 나머지만 조회
    
    [표현법]
    비교대상컬럼 in ('값1', '값2', ...)
*/

-- employee 테이블에서 부서코드가 'D6'이거나 'D5'이거나 'D8'인 사원명, 부서코드, 급여 조회
select emp_name, dept_code, salary
from employee
where dept_code in('D6', 'D5', 'D8');

-- employee 테이블에서 부서코드가 'D6', 'D5', 'D8'이 아닌 사원명, 부서코드, 급여 조회
select emp_name, dept_code, salary
from employee
where dept_code not in('D6', 'D5', 'D8');

/*
================================================================================
    
    <연산자 우선 순위>
    1. ()
    2. 산술연산자
    3. 연결연산자
    4. 비교연산자
    5. is, null / is not null
    6. between and
    7. not (논리)
    8. and (논리)
    9. or(논리)
*/
-- and가 or보다 우선순위가 높음
-- 직급코드가 J7이거나 J2인 사원들 중 급여가 200만원 이상인 사원들의 모든 컬럼 조회
select emp_name, job_code, salary
from employee
where job_code in ('J7','J2') and salary >= 2000000;

-- 1. 사수가 없고 부서배치도 받지 않은 사원들의 사원명, 사수사번, 부서코드 조회
select emp_name, manager_id, dept_code
from employee
where manager_id is null and dept_code is null;

-- 2. 연봉(보너스포함x)이 3000만원 이상이고 보너스를 받지 않는 사원들의 사번, 사원명, 연봉, 보너스 조회
select emp_name, salary*12 연봉, bonus
from employee
where salary*12 >= 30000000 and bonus is null;

-- 3. 입사일이 95/01/01 이상이고 부서배치를 받은 사원들의 사번, 사원명, 입사일, 부서코드 조회
select emp_id, emp_name, hire_date, dept_code
from employee
where hire_date >= '95/01/10' and dept_code is not null;

-- 4. 급여가 200만원 이상 500만원 이하고 입사일이 01/01/01 이상이고 보너스를 받지 않는 사원들의 사번, 사원명, 급여, 입사일, 보너스 조회
select emp_id, emp_name, salary, hire_date, bonus
from employee
where salary between 2000000 and 5000000 and hire_date > '01/01/01' and bonus is null;

-- 5. 보너스포함 연봉이 null이 아니고 이름에 '하'가 포함되어 있는 사원들의 사번, 사원명, 급여, 보너스포함연봉조회
select emp_id, emp_name, salary, (salary+salary*bonus)*12 "보너스포함 연봉"
from employee
where salary*12+salary*bonus is not null and emp_name like '%하%';

/*
================================================================================
    
    <order by절>
    select문 가장 마지막줄에 작성 뿐만 아니라 실행순서도 제일 마지막으로 실행
    
    [표현법]
    select 조회할 컬럼, 컬럼, 산술연산식 ...
    from 테이블명
    where 조건식
    order by 정렬기준의 컬럼명 or 별칭 | 컬럼 순서 [ASC|DESC] 오름차순이 default [nulls first | nulls last];
    
    - nulls first: null값이 있는 경우 데이터의 맨앞에 위치 (기본값 desc)
    - nulls last: null값이 있는 경우 데이터의 맨뒤에 위치 (기본값 asc)
*/

select emp_name, bonus
from employee
order by bonus desc nulls last;


-- 정렬기준을 여러개 사용
select emp_name, bonus, salary
from employee
order by bonus  desc, salary;

-- 전 사원의 사원명, 연봉 조회(내림차순)
select emp_name, salary*12 연봉
from employee
--order by 연봉 desc;  -- 별칭 사용 가능
order by 2 desc;         --  컬럼의 순서(숫자)가능






-- 1. JOB 테이블에서 모든 정보 조회
select *
from job;

-- 2. JOB 테이블에서 직급 이름 조회
select job_name
from job;

-- 3. DEPARTMENT 테이블에서 모든 정보 조회
select *
from department;

-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
select emp_name, email, phone, hire_date
from employee;

-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
select hire_date, emp_name, salary
from employee;

-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회 //다시
select emp_name, salary*12 연봉, 
(salary+salary*bonus)*12 as 총수령액, 
(salary+salary*bonus)*12-(salary*12*0.03) as 실수령액
from employee;

-- 7. EMPLOYEE테이블에서 JOB_CODE가 J1인 사원의 이름, 월급, 고용일, 연락처 조회
select emp_name, salary, hire_date, phone, job_code
from employee
where job_code = 'J1';

-- 8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
select emp_name, salary, ((salary*12) + (salary*bonus))-(salary*12*0.03) 실수령액, hire_date
from employee
where ((salary*12) + (salary*bonus))-(salary*12*0.03) >= 50000000;

-- 9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
select  *
from employee
where salary >= 4000000 and job_code = 'J2';

-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 
--     고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
select emp_name, dept_code, hire_date
from employee
where dept_code in ('D9', 'D5') and hire_date < '02/01/01';

-- 11. EMPLOYEE테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용을 조회
select *
from employee
where hire_date between '90/01/01' and '01/01/01';

-- 12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
select emp_name
from employee
where emp_name like '%연';

-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
select emp_name, phone
from employee
where not phone like '010%';

-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
--     고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회
select *
from employee
where email like '____$_%' escape '$' and hire_date between '90/01/01' and '00/12/01' and salary >= 2700000;
