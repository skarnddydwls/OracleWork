/*
        <시퀀스 SEQUENCE>
            자동으로 번호를 발생시켜주는 역할을 하는 객체
            정수값을 순차적으로 일정값씩 증가시키면서 생성해줌
            
            EX) 회원번호, 사원번호, 게시글번호, ...
*/

/*
        1. 시퀀스 생성
        
        [표현식]
        CREATE SEQUENCE 시퀀스명
        [START WITH 시작숫자]                          -> 처음 발생시킬 시작값 지정 (기본값 1)
        [INCREMENT BY 숫자]                          -> 몇씩 증가시킬 것인지 (기본값 1)
        [MAXVALUE 숫자]                                   -> 최대값 지정
        [MINVALUE 숫자]                                    -> 최소값 지정 (기본값 1)
        [CYCLE | NOCYCLE]                               -> 값 순환 여부 지정 (기본값 NOCYCLE)
        [NOCACHE | CACHE 바이트크기]             -> 캐시 메모리 할당 (기본값 CHCHE 20)
        
        * 캐시 메모리: 미리 발생될 값들을 생성해서 저장해두는 공간
                              매번 호출될 때 마다 새롭게 번호를 생성하는게 아니라
                              캐시메모리에 미리 생성된 값들을 가져다 쓸 수 있음 (속도가 빨라짐)
                              접속이 해제되면 => 캐시메모리에 미리 만들어 둔 번호들은 다 날라감
*/  
-- 시퀀스 생성
create SEQUENCE seq_test;

-- 옵션을 넣어 시퀀스 생성
create sequence seq_empno
start with 400
increment by 5
maxvalue 410
nocycle
nocache;

/*
        2. 시퀀스 사용
        
        시퀀스명.currval: 현재 시퀀스의 값(마지막으로 성공적으로 수행된 nextval의 값)
        시퀀스명.nextval: 시퀀스값에 일정값을 증가시켜서 발생된 값
                                    현재 시퀀스값에서 increment by 값 만큼 증가시킨 값
                                     = 시퀀스.currval + increment by 값
*/
select seq_empno.currval from dual;
-- nextval를 단 한 번도 수행하지 않은 이상 currval 할 수 없음
-- currval는 성공적으로 수행된 nextval의 값

select seq_empno.nextval from dual; --400
select seq_empno.currval from dual; --400
select seq_empno.nextval from dual; --405
select seq_empno.nextval from dual; --410

select seq_empno.nextval from dual; --오류
select seq_empno.currval from dual; --410

/*
        3. 시퀀스 구조 변경
        
        ALTER SEQUENCE 시퀀스명
        [INCREMENT BY 숫자]
        [MAXVALUE 숫자]
        [MINVALUE 숫자]
        [CYCLE | NOCYCLE]
        [CACHE | NOCACHE]
        
        ** START WITH는 변경 불가 **
*/
alter sequence seq_empno
increment by 10
maxvalue 500;

select seq_empno.nextval from dual; -- 410 + 10 = 420

-- 4. 시퀀스 삭제
drop sequence seq_empno;

--------------------------------------------------------------------------
-- 사원번호를 sequence로 생성
create sequence seq_eid
start with 400
nocache;

insert into employee (emp_id, emp_name, emp_no, job_code, hire_date)
values(seq_eid.nextval, '김삼순', '051212-1234567', 'J7', sysdate);

insert into employee (emp_id, emp_name, emp_no, job_code, hire_date)
values(seq_eid.nextval, '이사순', '051212-2234567', 'J4', sysdate);

