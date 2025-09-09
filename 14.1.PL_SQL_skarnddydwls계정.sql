/*
        <PL/SQL>
            오라클 자체에 내장되어 있는 절차적 언어
            SQL문장 내에서 변수의 정의, 조건처리(IF), 반복처리(LOOP, FOR, WHILE)등을 지원하여 SQL의 단점을 보완
            다수의 SQL문을 한 번에 실행 가능 (BLOCK 구조)
            
            * PL/SQL 구조
                - [선언부 (DECLARE SECTION)]: DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분
                - 실행부 (EXECUTABLE SECTION): BEGIN으로 시작, SQL문 또는 제어문(조건문, 반복문)등의 로직을 기술하는 부분
                - [예외처리부 (EXCEPTION SECTION)]: EXCEPTION으로 시작, 예외 발생 시 해결하기 위한 구문을 미리 기술해 둘 수 있는 부분                
*/
-- 화면에 출력하려면 반드시 ON으로 켜줘야 됨
set serveroutput on;

begin
        -- system.out.println("Hello World")  => 자바
        dbms_output.put_line('Hello World');
end;
/

/*
        1. DECLARE 선언부
            변수나 상수를 선언하는 공간(선언과 동시에 초기화도 가능)
            일반타입 변수, 래퍼런스 변수, ROW타입 변수
            
            1) 일반타입 변수 선언 및 초기화
                [표현식]
                변수명 [CONSTANT] 자료형 [:= 값]
*/

declare 
    eid number;
    ename varchar2(20);
    pi constant number := 3.14;
begin
    eid := 700;
    ename := '배정남';
    
    dbms_output.put_line(eid);
    dbms_output.put_line('이름: ' || ename);
    dbms_output.put_line('pi: ' || pi);
end;
/
  
declare
    eid number;
    ename varchar2(20);
    pi constant number := 3.14;
begin
    eid := &번호;
    ename := '&이름';
    
    dbms_output.put_line('eid: ' || eid);
    dbms_output.put_line('ename: ' || ename);
    dbms_output.put_line('pi: ' || pi);
end;
/

/*
        2) 레퍼런스 변수
            어떤 테이블의 어떤 컬럼의 데이터타입을 참조하여 그 타입으로 지정
            
            [표현법]
            변수명 테이블명.컬럼명%TYPE;
*/

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    sal employee.salary%type;
begin
    eid := '400';
    ename := '남궁용진';
    sal := 3000000;
    
    dbms_output.put_line('eid: ' || eid);
    dbms_output.put_line('ename: ' || ename);
    dbms_output.put_line('sal: ' || sal);
end;
/


declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    sal employee.salary%type;
begin
    -- 사번이 200번인 사원의 사번, 사원명, 급여 조회하여 각 변수에 대입
    select emp_id, emp_name, salary
    into eid, ename, sal
    from employee
    where emp_id = 201;
    
    dbms_output.put_line('eid: ' || eid);
    dbms_output.put_line('ename: ' || ename);
    dbms_output.put_line('sal: ' || sal);
end;
/

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    sal employee.salary%type;
begin
    -- 사번이 &사번인 사원의 사번, 사원명, 급여 조회하여 각 변수에 대입
    select emp_id, emp_name, salary
    into eid, ename, sal
    from employee
    where emp_id = &사번;
    
    dbms_output.put_line('eid: ' || eid);
    dbms_output.put_line('ename: ' || ename);
    dbms_output.put_line('sal: ' || sal);
end;
/

/*
        문제
        
        레퍼런스타입 변수로 eid, ename, jcode, sal, dtitle를 선언하고
        각 자료형 employee(emp_id, emp_name, job_code, salary), department(dept_title)를 참조하도록 설정
        
        사용자가 입력 사번의 사번, 사원명, 직급코드, 급여, 부서명 조회한 후 각 변수에 담아 출력
*/

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    jcode employee.job_code%type;
    sal employee.salary%type;
    dtitle department.dept_title%type;
begin
    select emp_id, emp_name, job_code, salary, dept_title
    into eid, ename, jcode, sal, dtitle
    from employee
    join department on (dept_code = dept_id)
    where emp_id = &사번;
    
    dbms_output.put_line('사번: ' || eid);
    dbms_output.put_line('이름: '|| ename);
    dbms_output.put_line('직급코드: ' || jcode);
    dbms_output.put_line('급여: ' || sal);
    dbms_output.put_line('부서이름: ' || dtitle);
end;
/

/*
        3) ROW타입 변수
            테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수
            
            [표현법]
            변수명 테이블명%ROWTYPE;
*/

declare
    e employee%rowtype;
begin
    select *
    into e
    from employee
    where emp_id = &사번;
    
    dbms_output.put_line('사원명: ' || e.emp_name);
    dbms_output.put_line('급여: ' || e.salary);
    -- dbms_output.put_line('보너스: ' || e.bonus);
    -- dbms_output.put_line('보너스: ' || nvl(e.bonus, '없음')); 타입이 안 맞아서 오류
    dbms_output.put_line('보너스: ' || nvl(e.bonus, 0));
end;
/

-- 오류
declare
    e employee%rowtype;
begin
    select emp_name, salary, bonus -- 무조건 *을 사용
    into e
    from employee
    where emp_id = &사번;
    
    dbms_output.put_line('사원명: ' || e.emp_name);
    dbms_output.put_line('급여: ' || e.salary);
    dbms_output.put_line('보너스: ' || nvl(e.bonus, 0));
end;
/
    
    
declare
    e employee%rowtype;
begin
    select *
    into e
    from employee
    where emp_id = &사번;
    
    dbms_output.put_line('사원명: ' || e.emp_name);
    dbms_output.put_line('급여: ' || e.salary);
    dbms_output.put_line('보너스: ' || nvl(e.bonus, 0));
end;
/


--------------------------------------------------------------
/*
        2. BEGIN 실행부
            
            <조건문>
            1) 단일 IF문
                IF 조건식 
                    THEN 실행내용;
                END IF;
*/
-- 사번을 입력받은 후 해당 사원의 사번, 사원명, 급여, 보너스율(%) 출력
-- 단, 보너스를 받지 않는 사원은 보너스율 출력전에 '보너스를 받지 않는 사원입니다' 출력

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    sal employee.salary%type;
    bonus employee.bonus%type;
begin
    select emp_id, emp_name, salary, nvl(bonus, 0)
    into eid, ename, sal, bonus
    from employee
    where emp_id = &사번;
    
    dbms_output.put_line('사번: ' || eid);
    dbms_output.put_line('사원명: ' || ename);
    dbms_output.put_line('급여: ' || sal);
    if bonus = 0
        then dbms_output.put_line('보너스를 받지 않는 사원입니다');
    end if;  
    dbms_output.put_line('보너스율: ' || bonus * 100 || '%'); 
end;
/

/*
        2) IF-ELSE문
            IF 조건식 
                THEN 실행내용;
                ELSE 실행내용;
            END IF;
*/

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    sal employee.salary%type;
    bonus employee.bonus%type;
begin
    select emp_id, emp_name, salary, nvl(bonus, 0)
    into eid, ename, sal, bonus
    from employee
    where emp_id = &사번;
    
    dbms_output.put_line('사번: ' || eid);
    dbms_output.put_line('사원명: ' || ename);
    dbms_output.put_line('급여: ' || sal);
    if bonus = 0
        then dbms_output.put_line('보너스를 받지 않는 사원입니다');
        else dbms_output.put_line('보너스율: ' || bonus * 100 || '%'); 
    end if;    
end;
/

-- 문제
/*
        레퍼런스 변수: eid, ename, dtitle, ncode
        참조컬럼: emp_id, emp_name, dept_title, national_code
        일반 변수: team(소속)
        
        실행: 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 변수에 대입
                단, ncode값이 ko일 경우 => team 변수에 '국내팀'
                     ncode값이 ko가 아닐 경우 => team 변수에 '해외팀'
*/    

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    dtitle department.dept_title%type;
    ncode location.national_code%type;
    team varchar2(20);
begin
    select emp_id, emp_name, dept_title, national_code
    into eid, ename, dtitle, ncode
    from employee
    join department on (dept_id = dept_code)
    join location on (local_code = location_id)
    where emp_id = &사번;
    
    dbms_output.put_line('사번: ' || eid);
    dbms_output.put_line('이름: ' || ename);
    dbms_output.put_line('부서명: ' || dtitle);
    if ncode = 'KO' 
        then team := '국내팀';
        else team := '해외팀';
    end if;
    dbms_output.put_line('소속: ' || team);
end;
/
    
    
/*
        3) IF-ELSE문
            IF 조건식1 THEN 실행내용1;
            ELSIF 조건식2 THEN 실행내용2;
            ELSIF 조건식3 THEN 실행내용3;
            ELSE 실행내용4;
            END IF;
*/

-- 사용자로부터 점수를 입력받아서 학점 출력
-- 변수 2개 필요 점수, 학점

declare
    score number;
    grade char(1);
begin
    score := &점수;
    
    if score >=90 then grade := 'A';
    elsif score >= 80 then grade := 'B';
    elsif score >= 70 then grade := 'C';
    elsif score >= 60 then grade := 'D';
    else grade := 'F';
    end if;
    
    dbms_output.put_line('당신의 점수는 ' || score || '이고, 학점은 ' || grade || '학점 입니다.');
end;
/
    
-- 문제 
/*
        사용자에게 입력받은 사번의 급여를 조회하여 sal 변수에 입력하고
        - 500만원 이상이면 '고급'
        - 300만원 이상이면 '중급'
        - 그 외는 '초급'
        
        출력: 해당 사원의 급여 등급은 ?? 입니다.
*/

declare
    sal employee.salary%type;
    grade char(10);
begin
    sal := &급여;
    
    if sal >= 5000000 then grade := '고급';
    elsif sal >= 3000000 then grade := '중급';
    else grade := '초급';
    end if;
    
    dbms_output.put_line('해당 사원의 급여 등급은 ' || grade ||'입니다');
    
end;
/
    

  
        