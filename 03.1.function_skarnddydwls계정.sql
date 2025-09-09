/*
    <함수 function>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
    
    - 단일행 함수: n개 값을 읽어들여 n개의 결과값 반환(매 행마다 함수 실행)
    - 그룹 함수: n개 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
    
    >> select절에 단일행 함수와 그룹함수를 함께 사용 불가
    
    >> 함수식을 기술할 수 있는 위치: select절, where절, order by절, having절
*/

----------------------------단일 행 함수------------------------------------
/*
=======================================================================
                                                                           <문자처리 함수>
=======================================================================
    * LENGTH/ LENGTNB => NUMBER로 반환
    
    LENGTH(컬럼|'문자열'): 해당 문자열의 글자 수 반환
    LENGTNB(컬럼|'문자열'): 해당 문자열의 BYTE수 반환
        - 한글: XE버전일 때 => 1글자당 3BYTE(김, ㄱ, ㅠ -> 1글자에 해당)
                    EE버전일 때 => 1글자당 2BYTE
        - 그외: 1글자당 1BYTE
*/

select length('오라클'), lengthb('오라클')
from dual; --오라클에서 제공하는 가상테이블

select length('oracle') || '글자',  lengthb('oracle')|| 'byte'
from dual;

select emp_name, length(emp_name), lengthb(emp_name), email, length(email), lengthb(email)
from employee;

/*
    INSTR: 문자열로부터 특정문자의 시작위치(index)를 찾아 반환(반환형: number)
        - oracle에서는 index는 1부터 시작, 찾을 문자가 없으면 0반환
        
    INSTR(컬럼| '문자열'| '찾고자하는 문자', [찾을위치의 시작값, [순번]])
        - 찾을위치의 시작 값
            > 1: 앞에서부터 찾기(기본값)
            > -1: 뒤에서부터 찾기  
*/

select instr('javascriptjavaoracle', 'a') from dual;
select instr('javascriptjavaoracle', 'a', 1) from dual;
select instr('javascriptjavaoracle', 'a', 3) from dual; -- 3부터 시작 
select instr('javascriptjavaoracle', 'a',-1) from dual;
select instr('javascriptjavaoracle', 'a', 1, 3) from dual; -- 앞에서부터, 3번째 
select instr('javascriptjavaoracle', 'a', -1, 2) from dual; -- 뒤에서부터, 2번째

-- employee 테이블에서 email의 ' _ '의 index번호와 ' @ '의 index번호 찾기
select emp_name, email, instr(email,'_') "_의 위치" , instr(email,'@') "@의 위치" from employee;

/*
    SUBSTR: 문자열에서 특정 문자열을 추출하여 반환(반환형은 character)
    
    SUBSTR('문자열', position, [length])
        - position: 문자열을 추출할 시작 위치 index반환
        - length: 추출할 문자의 개수 (생략시 맨마지막까지 추출)
*/

select substr('oraclehtmlcss', 7) from dual;
select substr('oraclehtmlcss', 7, 4) from dual;
select substr('oraclehtmlcss', -7, 4) from dual;

-- employee 테이블에서 주민번호의 성별만 추출하여 사원명, 주민번호, 성별 조회
select emp_name, emp_no, substr(emp_no, 8,1) 성별
from employee;

-- employee 테이블에서 여자사원들만 사원번호, 사원명, 성별 조회
select emp_id, emp_name, substr(emp_no, 8,1) 성별
from employee
where emp_no like '_______2%' or emp_no like '_______4%'; 
-- substr(emp_no, 8,1) = '2'
-- substr(emp_no,8,1) in ('2','4')

-- employee 테이블에서 남자사원들만 사원번호, 사원명, 성별 조회, 사원명의 오름차순 정렬
select emp_id, emp_name, substr(emp_no, 8,1) 성별
from employee
--where emp_no like '_______2%' or emp_no like '_______4%'; 
-- substr(emp_no, 8,1) = '2'
where substr(emp_no,8,1) in ('1','3')
order by 2 ; -- select 두번째 위치인가봄

-- employee 테이블에서 email에서 아이디만 추출하여 사원명, 이메일, 아이디 조회
select emp_name, email, substr(email,1, instr(email,'@')-1) 아이디
from employee;

/*
==========================================================
    LPAD / RPAD: 문자열을 조회할 때 통일감있게 조회하고자 할 때(반환형: character)
    
    LPAD / RPAD('문자열', 최종적으로 반환할 문자의 길이, [덧붙이고자 하는 문자])
    문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N의 길이만큼 문자열 반환
*/
-- 20길이 중 email 컬럼값은 오른쪽 정렬하고 공백은 나머지 부분은 공백으로 채움
select EMP_NAME, LPAD(EMAIL, 20)
from EMPLOYEE;

select EMP_NAME, LPAD(EMAIL, 20,'#')
from EMPLOYEE;

select EMP_NAME, RPAD(EMAIL, 20,'#')
from EMPLOYEE;

-- employee 테이블에서 사번, 사원명, 주민번호 출력(123456-2******)형식으로 출력
select emp_id, emp_name, rpad(substr(emp_no, 1, 8),14,'*') 주민등록번호
from employee;

select emp_id, emp_name, rpad(emp_no, 8,'*') || '******' "주민등록번호" -- || 이거 쓰면 이어붙이기가 가능하구나
from employee;


/*
==========================================================
    LTRIM / RTRIM: 문자열에서 특정문자를 제거한 나머지 반환(반환형: character)
    TRIM: 문자열의 앞/뒤 양쪽에 지정한 문자들을 제거한 나머지 반환(반환형: character)
    
    LTRIM / RTRIM('문자열', [제거하고자하는 문자]) 
     => 제거하고자하는 문자를 생략하면 공백제거
    TRIM([LEADING | TRALLING | BOTH] 제거하고자하는 문자들 FROM '문자열'])
     => 제거하고자하는 문자는 한 개만 가능
*/

select ltrim('     tjoeun     ' || '컴퓨터아카데미') from dual;
select ltrim('javajavascript','java') from dual;
select ltrim('bacbaacfabcd', 'abc') from dual;
select ltrim('2364469ldkfjsold8415235', '0123456789') from dual;

select rtrim('     tjoeun     ' || '컴퓨터아카데미') from dual;
select rtrim('bacbaacfabcd', 'abc') from dual; -- ??

-- 기본값 both로 양쪽의 문자열을 제거
select trim(both 'a' from 'aaadks78aaa') from dual;
select trim('a' from 'aaadks78aaa') from dual;
select trim(leading 'a' from 'aaadks78aaa') from dual; -- 앞 지우기
select trim(trailing 'a' from 'aaadks78aaa') from dual; -- 뒤 지우기

/*
==========================================================
    LOWER / UPPER / INITCAP: 문자열을 대수문자로 변환 및 단어의 첫글자만 대문자로 변환
    
    lower/upper/initcap('문자열')
*/
select lower(' Java JavaScript') from dual;
select upper('Java JavaScript') from dual;
select initcap('Java JavaScript') from dual;

/*
==========================================================
    CONCAT: 문자열 두 개를 전달받아 하나로 합쳐진 결과 반환
    CONCAT('문자열','문자열)
*/
select concat('Oracle','오라클') from dual;
select 'Oracle'||'오라클' from dual;

select concat('Oracle', '오라클','남궁용진','존나졸리다') from dual;
-- 오라클 낮은 버전에서는 문자열 두 개밖에 안됨

/*
==========================================================
    REPLACE: 기존 문자열을 새로운 문자열로 바꿈
    
    replace('문자열', '기존문자열', '변경할 문자열')
*/
select replace('Oracle 공부중', 'Oracle', 'Java') from dual;

-- employee 테이블에서 사원명, email, 이메일변경(aie.or.kr -> naver.com) 
select emp_name, email 변경전, replace(email, 'aie.or.kr', 'naver.com') 변경후
from employee;


/*
=======================================================================
                                                                           <문자처리 함수>
=======================================================================
    
    ABS: 숫자의 절대값
    
    ABS(number)
*/

select abs(-10) from dual;
select abs(-3.14) from dual;

/*
    MOD: 두 수를 나눈 나머지 값
    
    MOD(number, number)
*/
select mod(10,3) from dual;
select mod(20.1,17) from dual; -- 소수는 잘 사용 안 함

/*
    ROUND: 반올림한 결과 반환
    
    round(number,[반올림할 위치])
        - 위치 생략시 위치는 0 (즉, 정수로 반올림)
*/
select round(1234.56) from dual;
select round(123.444) from dual;
select round(1234.5678, 2) from dual; -- 셋째자리에서 반올림
select round(1234.56, 4) from dual; -- 오류 안 남
select round(1234.56, -2) from dual; -- 정수에서 반올림을 하네 

/*
    CEIL: 무조건 올림
    
    ceil(number)
*/
select ceil(12.1) from dual;

/*
    FLOOR: 무조건 내림
    
    floor(number)
*/
select floor(12.9) from dual;
select floor(-12.9) from dual; -- -13이 더 낮아서 -13으로 내려짐

/*
    TRUNC: 위치 지정 가능한 버림처리
    
    trunc(number , [위치])
*/
select trunc(12.123456) from dual; -- 위치 없으면 다 버림
select trunc(12.123456, 2) from dual;
select trunc(12.123456, -1) from dual;
select trunc(-1234.123,-3) from dual;


/*
=======================================================================
                                                                           <날짜처리 함수>
=======================================================================
    
    SYSDATE: 시스템 날짜 및 시간 반환
*/
select sysdate from dual;

/*
    MONTHS_BETWEEN(DATE1, DATE2): 두 날짜 사이의 개월 수 반환
*/
select emp_name, hire_date, ceil(sysdate-hire_date) 근무일수
from employee;

select emp_name, hire_date, ceil(months_between(sysdate, hire_date)) 근무개월수
from employee;

select emp_name, hire_date, concat(ceil(months_between(sysdate, hire_date)),'자') 근무개월수
from employee;

select emp_name, hire_date, ceil(months_between(sysdate, hire_date)) || '개월차' 근무
from employee;

/*
    ADD_MONTHS(DATE, NUMBER): 특정날짜에 해당 숫자만큼 개월수를 더해 그 날짜를 반환
*/
select add_months(sysdate, 6) from dual;

-- employee 테이블에서 사원명, 입사일, 정직원이된 날짜(입사일로부터 6개월 수숩) 조회
select emp_name, hire_date, add_months(hire_date, 6) "정직원이 된 날짜"
from employee;

/*
    NEXT_DAY(DATE, 요일(문자|숫자):  특정 날짜 이후에 가까운 해당 요일의 날짜를 반환
*/
select sysdate, next_day(sysdate, '월요일') from dual;
select sysdate, next_day(sysdate, '월') from dual;

-- 1: 일, 2: 월, 3: 화 ...
select sysdate, next_day(sysdate,2) from dual;
-- select sysdate, next_day(sysdate, 'MONDAY') from dual; 오류 남(현재 언어가 korea이기 때문)

-- 언어변경
alter session set nls_language = AMERICAN;
alter session set nls_language = KOREAN;

/*
    LAST_DAY(DATE): 해당 월의 마지막 날짜를 반환해주는 함수
*/
select last_day(sysdate) from dual;

-- employee 테이블에서 사원명, 입사일, 입사한달의 마지막 날짜 조회


/*
    EXTRACT: 특정날짜로부터 년도 |월|일 값을 추출하여 반환한느 함수(반환형: number)
    
    extract(year from date): 년도 추출
    extract(month from date): 월만 추출
    extract(day from date): 일만 추출
*/
-- employee 테이블에서 사원명, 입사년도, 입사월, 입사일 조회
select emp_name, extract(year from hire_date) 년, extract(month from hire_date) 월, extract(day from hire_date) 일
from employee
order by 년, 월, 일;


/*
=======================================================================
                                                                           <형변환 함수>
=======================================================================
    
    TO_CHAR: 숫자 또는 날짜 타입의 값을 문자타입으로 변환시켜주는 함수
                    반환결과를 특정 형식에 맞춰 출력할 수도 있음
                    
    TO_CHAR(숫자|날짜, [포멧])
    
------------------------------- 숫자 -> 문자 --------------------------------

    9: 해당 자리의 숫자를 의미 
        - 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표시
    0: 해당 자리의 숫자를 의미
        - 값이 없을 경우 0으로 표시하면 숫자의 길이를 고정적으로 표시할 때 주로 사용
    FM: 해당 자리값이 없을 경우 자리 차지 하지 않음
*/
select to_char(1234) from dual;
select to_char(1234, '999999') from dual; -- 6칸 확보, 왼쪽 정렬, 빈칸 공백
select to_char(1234, '000000') from dual; -- 6칸 확보, 왼쪽 정렬, 빈칸 0으로 채움+
select to_char(1234, 'L99999') from dual; -- 현재 설정된 나라(Local)의 화폐단위(빈칸 공백): 오른쪽 정렬

select to_char(1234, 'L99,999') from dual;

select emp_name, to_char(salary, 'L99,999,999') 월급 , to_char(salary*12,'L99,999,999') 연봉
from employee
order by 월급 desc;


select to_char(123.456, 'FM9990.999'),
            to_char(1234.45, 'FM9990.999'),
            to_char(0.1000, 'FM9990.999'),
            to_char(0.1000, 'FM9999.999')
from dual;

select to_char(123.456, '999990.999'),
            to_char(123.45, '9990.999'), to_char(0.1000,'9990.999'), to_char(0.1000,'9999,999')
from dual;

/*
------------------------------- 날짜 -> 문자 --------------------------------
-- 시간
*/
select to_char(sysdate,'AM') korea, to_char(sysdate,'PM', 'NLS_DATE_LANGUAGE=AMERICAN') american
FROM dual; -- 'am', 'pm' 뭘 쓰던 상관없음

select to_char(sysdate, 'am hh:mi:ss') from dual; -- HH: 12시간 형식
select to_char(sysdate, 'hh24:mi:ss') from dual; --hh24: 24시간 형식

-- 날짜
select to_char(sysdate, 'yyyy-mm-dd day') from dual; -- 월요일
select to_char(sysdate, 'yyyy-mm-dd dy') from dual;   -- 월
select to_char(sysdate, 'mon, yyyy') from dual;

-- 2025년 09월 01일 월요일 출력
select to_char(sysdate, 'yyyy"년" mm"월" dd"일" day') from dual;
select to_char(sysdate,'dl') from dual;

-- employee 테이블에서 사원명, 입사일 조회 (25-09-01)
select emp_name, to_char(hire_date, 'yy-mm-dd')
from employee;

select emp_name, to_char(hire_date, 'dl')
from employee;

-- 년도
/*
    YY: 현재세기가 앞에 붙는다
     ex) 050101 -> 2005,  780101 ->2078
    RR: 50년을 기준으로 50보다 작으면 현재세기, 50보다 크거나 같으면 이전세기가 붙음
     ex) 050101 -> 2005,  780101 ->1978
*/
select to_char(sysdate, 'yyyy'), to_char(sysdate,'yy'), to_char(sysdate,'rrrr'), to_char(sysdate,'rr'), to_char(sysdate,'year')
from dual;

-- 월
select to_char(sysdate, 'mm'), to_char(sysdate, 'mon'), to_char(sysdate,'month'), to_char(sysdate,'rm')
from dual;

alter session set nls_language = american;
alter session set nls_language = korean;

-- 일
select 
to_char(sysdate, 'ddd'),  -- 년을 기준으로 몇일째
to_char(sysdate,'dd'), -- 월을 기준으로 몇일째
to_char(sysdate,'d')  -- 일주일을 개준으로 몇일째 (일요일이 1)
from dual;

-- 요일
select to_char(SYSDATE, 'day'), to_char(sysdate, 'dd') from dual;


/*
---------------------------- 숫자 또는 문자-> 문자 --------------------------------

    TO_DATE: 숫자 또는 문자타입을 날짜타입으로 변환
    
    to_date(숫자|문자, [포멧])
*/
select to_date(20100901) from dual;
select to_date(100901) from dual;

select to_date(010901) from dual; -- 앞에 0이 붙으면 오류가 남
select to_date('010901') from dual; -- 문자열 표시하면 오류가 해결됨

select to_date('041028 103025', 'yymmdd hhmiss') from dual;
select to_date('041028 143025', 'yymmdd hhmiss') from dual; -- 오류: 오전, 오후로는 14시가 없음
select to_date('041028 143025', 'yymmdd hh24miss') from dual;

select to_date('041028 143025', 'yy-mm-dd hh24miss') from dual; -- 밑에서럼 포멧을 넣어줘야 함
select to_char(to_date('041028 103030' ,'yymmdd hhmiss'), 'yy-mm-dd hh:mi:ss') from dual; 

select to_date('040725', 'rrmmdd') from dual; -- 현재세기
select to_date('970725', 'rrmmdd') from dual; -- 이전세기
select to_char(to_date('970725', 'rrmmdd'), 'yyyy-mm-dd') from dual; -- 이전세기

select to_char(to_date('97/07/25', 'rr/mm/dd'), 'yyyy/mm/dd') from dual; -- 현재세기

/*
------------------------------ 문자-> 숫자 --------------------------------

    TO_NUMBER: 문자 타입의 데이터를 숫자타입으로 변환
    
    TO_NUMBER(문자, [포멧])
*/
select to_number('01234567') from dual; -- 0이 사라짐: 숫자로 변경됨
select '1000000'+'550000' from dual; -- 자동 형변환(숫자로)
select '1,000,000' + '550,000' from dual; -- ( , ) 때문에 오류가 남 특수기호가 있으면 자동형변환 안됨
select to_number('1,000,000' , '9,999,999') + to_number('550,000', '999,999') from dual;



/*
=======================================================================
                                                                           <NULL처리 함수>
=======================================================================
    
    NVL(컬럼, 해당컬럼값이 null일때 반환할 값)
*/
select emp_name, nvl(bonus, 0)
from employee;

-- 모든 사원의 이름, 보너스포함 연봉
select emp_name, (salary*nvl(bonus,0) + salary)*12
from employee;

-- 모든 사원의 사원명, 부서코드조회(만약 부서코드가 null이면 '부서없음'으로 출력)
select emp_name, nvl(dept_code, '부서없음')
from employee;

/*
    NVL2(컬럼, 반환값1, 반환값2)
     - 컬럼값이 존재하면 반환값1을 반환, 존재하지 않으면 반환값2를 반환
*/

-- employee에서 사원명, 급여, 보너스, 성과급(보너스를 받는 사람은 50%, 보너스를 못받은 사람은 10%)
select emp_name, salary, nvl(bonus,0) 보너스, nvl2(bonus, salary*0.5, salary*0.1) 성과급 -- salary * nvl2(bonus, 0.5, 0.1) << 이렇게 써도 됨
from employee;

-- employee에서 사원명, 부서(부서에 속해있으면 '부서있음', 아니면 '부서없음')
select emp_name, nvl2(dept_code, 'O', 'X') "부서유/무"
from employee;

/*
    NULLIF(비교대상1, 비교대상2)
        - 2개의 값이 일치하면 null 반환
        - 2개의 값이 다르면 비교대상1 값을 반환
*/
select nullif('123','123') from dual;
select nullif('1234','123') from dual;


/*
=======================================================================
                                                    <선택 함수>
=======================================================================

    DCCODE (비교하고자하는 대상(컬럼| 산술연산| 함수식), 비교값1, 결과값1, 비교값2, 결과값2, ...)
    
    *프로그램의 switch와 같음
*/

-- employee 테이블에서 사번, 사원명, 주민번호, 성별
select emp_id, emp_name, emp_no,
decode(substr(emp_no,8,1), '1', '남','2','여','3','남','여') 성별
from employee;

-- employee 테이블에서 사번, 사원명, 직급코드, 급여, 각 직급별로 인상한 급여 조회
/* J7인 사원은 급여를 10% 인상,
    J6인 사원은 급여를 15% 인상,
    J5인 사원은 급여를 20% 인상,
    이외 모든 사원은 급여를 5%인상 */
select emp_id, emp_name, job_code, salary,
        decode(job_code,'J7', salary*1.1, 'J6', salary*1.15,'J5', salary*1.2, salary*1.05) "인상된 급여"
from employee;

/*
    CASE WHEN THAN
    END
    
    case when 조건식1 then 결과값1
            when 조건식2 then 결과값2
            ...
            else 결과값
    end
    
    *프로그램의 if-else와 동일
*/

-- employee 테이블에서 사원명, 급여, 급여에 따른 등급
/* 고급: 5백만원 이상 인 사원
     중급: 5백만원 미만 ~ 3백만원 이상 인 사원
     초급: 3백만원 미만 인 모든 사원 */
select emp_name, salary, 
        case when salary >= 5000000 then '고급'
        when salary >= 3000000 then '중급'
        else '초급'
        end 등급
from employee;

/*
=======================================================================
                                                    <그룹 함수>
=======================================================================

    SUM(컬럼(NUMBER타입)): 해당 컬럼값들의 총 합계를 구해 반환하는 함수
*/
-- employee 테이블에서 전 사원의 급여의 합
select sum(salary)
from employee;

-- employee 테이블에서 남자 사원의 급여의 합
select sum(salary) "남자 사원의 총 급여"
from employee
where substr(emp_no,8,1) in ('1','3');
-- WHERE DECODE(SUBSTR(EMP_NO, 8, 1), '1','남','3','남') = '남'
-- WHERE DECODE(SUBSTR(EMP_NO, 8, 1), '1','남','2','여','3','남','여') = '남'

-- employee 테이블에서 부서코드가 'D5'인 사원의 총 연봉(보너스 포함)의 합 조회
select sum(salary*nvl(bonus,0) + salary)*12
from employee
where dept_code = 'D5';

-- employee 테이블에서 전 사원의 급여의 합(출력: \111,111,111)
select to_char(sum(salary),'L999,999,999')
from employee;

/*
    AVG(컬럼(NUMBER 타입)): 해당 컬럼값들의 평균 반환
*/
-- employee 테이블에서 전 사원의 급여의 평균 조회
select avg(salary)
from employee;

select round(avg(salary))  -- round: 반올림한 결과 반환
from employee;

select round(avg(salary), 2) -- 두 번째 자리까지 나타냄
from employee;

--------------------------------------------------------------------------------
/*
    * MIN(컬럼(모든타입)) : 해당 컬럼 값들 중 가장 작은값 반환
    * MAX(컬럼(모든타입)) : 해당 컬럼 값들 중 가장 큰값 반환
*/
SELECT MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE)
FROM EMPLOYEE;

SELECT MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
    * COUNT(*|컬럼|DISTINCT컬럼) : 행의 갯수 반환
    
      - COUNT(*) : 조회된 결과의 모든 행의 갯수 반환
      - COUNT(컬럼) : 제시한 컬럼의 NULL값을 제외한 행의 갯수 반환
      - COUNT(DISTINCT 컬럼) : 해당 컬럼값에서 중복을 제거한 행의 갯수 반환
*/
-- EMPLOYEE테이블에서 전체 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 여자 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN('2', '4');

-- EMPLOYEE테이블에서 보너스를 받는 사원의 수
SELECT COUNT(BONUS)
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 부서배치를 받은 사원의 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 현재 사원이 총 몇개의 부서에 분포되어있는지 조회
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

-- 연습문제 

-- 1. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
select emp_name, 
to_char(to_date(substr(emp_no,1,2),'yy'), 'yy') 생년,
to_char(to_date(substr(emp_no,3,4),'mm'), 'mm') 생월,
to_char(to_date(substr(emp_no,5,6),'dd'), 'dd') 생일
from employee;
-- 2. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
select emp_name, rpad(substr(emp_no,1,8),14,'*') 주민등록번호
from employee;
-- 3. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
--   (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
select emp_name, abs(round((hire_date - sysdate))) 근무일수1, round((sysdate - hire_date)) 근무일수2
from employee;
-- 4. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
select *
from employee
where mod(emp_id, 2) != 0;
-- 5. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
select *
from employee
where round(sysdate - hire_date) / 365 >= 20 ; 
-- 6. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
select emp_name, to_char(salary, '9,999,999') 급여
from employee;
-- 7. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이 조회
--   (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며 
--   나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)
select emp_name, dept_code, to_char(to_date(substr(emp_no,1,6)), 'yy"년"mm"월"dd"일"') "생년월일"
from employee;
-- 8. EMPLOYEE테이블에서 부서코드가 D5, D6, D9인 사원만 조회하되 D5면 총무부
--   , D6면 기획부, D9면 영업부로 처리(EMP_ID, EMP_NAME, DEPT_CODE, 총무부)
--    (단, 부서코드 오름차순으로 정렬)
select emp_id, emp_name, dept_code
from employee
where dept_code in ('D5', 'D6', 'D9')
order by dept_code;
-- 9. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리, 
--    주민번호 앞자리와 뒷자리의 합 조회
select emp_name, substr(emp_no,1,6) 앞자리, substr(emp_no,8) 뒷자리
from employee
where emp_id = 201;
-- 10. EMPLOYEE테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회
select dept_code, (salary*nvl(bonus,0) + salary)*12 연봉
from employee
where dept_code = 'D5';
-- 11. EMPLOYEE테이블에서 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
--      전체 직원 수, 2001년, 2002년, 2003년, 2004년\