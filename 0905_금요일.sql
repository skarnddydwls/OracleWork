/*
    * DDL(Data Definition Language) : 데이터 정의 언어
      오라클에서 제공하는 객체를 만들고(CREATE), 구조를 변경(ALTER)하고, 구조 자체를 삭제(DROP)하는 언어
      즉, 실제 데이터 값이 아닌 구조 자체를 정의하는 언어
      주로 DB관리자, 설계자가 사용함
      
      오라클에서 객체(구조) : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 인덱스(INDEX), 
                            패키지(PACKAGE), 트리거(TRIGGER), 프로시져(PROCEDURE), 
                            함수(FUNCTION), 동의어(SYNONYM), 사용자(USER)
*/
--==============================================================================
/*
        <CREATE>
        객체를 생성하는 구문
*/
--------------------------------------------------------------------------------
/*
    1. 테이블 생성
       - 테이블 : 행(ROW)과 열(COLUMN)로 구성되는 가장 기본적인 데이터베이스 객체
                 모든 데이터들은 테이블을 통해 저장됨
                 (DBMS용어 중 하나로, 데이터를 일종의 표 형태로 표현한 것)
                 
      [표현식]
      CREATE TABLE 테이블명 (
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        컬럼명 자료형,
        ....
      );
      
      * 자료형
        - 문자 (CHAR(바이트크기) | VARCHAR2(바이트크기)) -> 반드시 크기지정 해야됨
          > CHAR : 최대 2000BYTE까지 지정 가능
                   고정길이(지정한 크기보다 더 적은값이 들어와도 공백으로 채워서 처음 지정한 크기만큼 고정)
                   고정된 데이터를 넣을 때 사용
          > VARCHAR2 : 최대 4000BYTE까지 지정 가능
                       가변길이(담긴 값에 따라 공간의 크기가 맞춰짐)
                       몇글자가 들어올지 모를 경우 사용
        - 숫자(NUMBER)
        - 날짜(DATE)
*/
-- 회원 정보를 담는 테이블 MEMBER생성
CREATE TABLE MEMBER (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR(13),
    EMAIL VARCHAR(50),
    MEM_DATE DATE
);

--------------------------------------------------------------------------------
/*
    2. 컬럼에 주석 달기(설명)
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
    
    >> 잘못 작성하였을 경우 수정후 다시 실해하면 됨(덮어쓰기 됨)
*/
COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원명';
COMMENT ON COLUMN MEMBER.GENDER IS '성별(남,여)';
COMMENT ON COLUMN MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

-- 테이블에 데이터를 추가시키는 구문
-- INSERT INTO 테이블명 VALUES();
INSERT INTO MEMBER VALUES(1, 'user01', 'pass01', '김민준', '남', '010-1234-5678', 'kim@naver.com', '25/09/01');
INSERT INTO MEMBER VALUES(2, 'user02', 'pass02', '이서연', '여', null, null, sysdate);

/*
    <제약 조건 CONSTRAINTS>
        - 원하는 데이터값 (유효한 형식의 값)만 유지하기 위해 특정 컬럼에 설정하는 제약
        - 데이터 무결성 보장을 목적으로 한다
            : 데이터에 결함이 없는 상태, 즉 데이터가 정확하고 유효하게 유지된 상태
            1) 개체 무결성 제약 조건: not null, unique, primary key 조건 위배
            2) 참조 무결성 제약 조건: foreing key(외래키) 조건 위배
            
        * 종류: not null, unique, primary key, check(조건), foreing key
        
        * 제약 조건을 부여하는 방식 두 가지
            1) 컬럼 레벨 방식: 컬럼명 자료형 옆에 기술
            2) 테이블 레벨 방식: 모든 컬럼들을 나열한 수 마지막에 기술 
*/

/*
    NOT NULL 제약 조건
        : 해당 컬럼에 반드시 값이 존재해야만 할 경우 (즉, 해당 컬럼에 절대 null이 들어오면 안되는 경우)
        삽입/ 수정시 null 값을 허용하지 않도록 제한
        
        ** 주의사항 ** 
        : 컬럼 레벨 방식으로만 할 수 있음, 테이블 레벨 방식으로는 불가
*/
-- 컬럼 레벨 방식
create table mem_notnull(
    mem_no number not null,
    mem_id varchar2(20) not null,
    mem_pwd varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3),
    phone varchar2(13),
    email varchar2(50)
);

insert into mem_notnull values(1, 'user1','pass01','남궁용진','남', null, null);
insert into mem_notnull values(2,'user2',null,'백승민','여',null,'elelte991@tukorea.ac.kr');
-- not null 제약조건 위반으로 오류 발생
    
insert into mem_notnull values(2,'user1','pass02','백승민','여',null,'elelte991@tukorea.ac.kr');
-- 아이디가 중복되어도 잘 추가 됨

/*
    UNIQUE 제약 조건
        해당 컬럼에 중복된 값이 들어가서는 안 되는 경우
        컬럼값에 중복값을 제한하는 제약 조건
        삽입/ 수정시 기존에 있는 데이터 중 중복값이 있을 경우 오류 발생
*/
-- 컬럼 레벨 방식
create table mem_unique (
    mem_no number not null,
    mem_id varchar(20) not null unique,
    mem_pass varchar(20) not null,
    mem_name varchar(20) not null,
    gender char(3),
    phone varchar(13),
    email varchar(50)
);

-- 테이블 레벨 방식
create table mem_unique2 (
    mem_no number not null,
    mem_id varchar(20) not null ,
    mem_pass varchar(20) not null,
    mem_name varchar(20) not null,
    gender char(3),
    phone varchar(13),
    email varchar(50),
    unique (mem_id)
);

create table mem_unique3 (
    mem_no number not null,
    mem_id varchar(20) not null ,
    mem_pass varchar(20) not null,
    mem_name varchar(20) not null,
    gender char(3),
    phone varchar(13),
    email varchar(50),
    unique (mem_id),
    unique (mem_no) -- 이렇게 따로따로 넣어줘야 됨
);

create table mem_unique4 (
    mem_no number not null,
    mem_id varchar(20) not null ,
    mem_pass varchar(20) not null,
    mem_name varchar(20) not null,
    gender char(3),
    phone varchar(13),
    email varchar(50),
    unique (mem_id, mem_no) -- 이렇게 넣으면 조합으로 묶여서 unique가 됨
);
/*
1, id1 -> 1개
1, id2 -> 2개
2, id1 -> 3개 
1, id2 -> 오류
*/


-- mem_unique2 => mem_id에 unique
-- mem_unique3 => mem_id에 unique, mem_no에 unique
-- mem_unique4 => mem_id와 mem_no에 unique

insert into mem_unique2 values(1, 'user01', 'pass01', '강하영', null, null, null);
insert into mem_unique2 values(2, 'user01', 'pass02', '남궁하영', null, null, null);
-- unique 제약조건 위배 (id가 동일), insert 실패

insert into mem_unique3 values(1, 'user01', 'pass01', '강하영', null, null, null);
insert into mem_unique3 values(2, 'user02', 'pass02', '남궁하영', null, null, null);
insert into mem_unique3 values(4, 'user01', 'pass02', '남궁하영', null, null, null);
-- unique 제약조건 위배 (id가 동일), insert 실패
insert into mem_unique3 values(2, 'user03','pass01','최하영', null,null,null);
-- unique 제약조건 위배 (no이 동일), insert 실패

insert into mem_unique4 values(1, 'user01', 'pass01', '강하영', null, null, null);
insert into mem_unique4 values(2, 'user02', 'pass02', '남궁하영', null, null, null);
insert into mem_unique4 values(1, 'user02', 'pass01', '강하영', null, null, null);
-- no과 id의 조합으로 unique를 걸어놨기에 no이 같아도 id가 다르기에 insert 성공
insert into mem_unique4 values(2, 'user02', 'pass01', '최하영', null, null, null);
-- no과 id의 조합이 동일하므로 unique 제약조건 위배, insert 실패

/*
--------------------------------------------------------------------------------------------------------

    제약 조건 부여시 제약조건명까지 지어주는 방법
    
    >> 컬럼 레벨 방식
        create table 테이블명 (
                컬럼명 자료형 [constraint 제약조건명] 제약조건,
                컬럼명 자료형 
                ...
        );
        
    >> 테이블 레벨 방식
        create table 테이블명 (
                컬럼명 자료형,
                컬럼명 자료형,
                ...
                [constraint 제약조건명] 제약조건 (컬럼)
        );
*/

create table mem_unique5 (
    mem_no number constraint memno_nn not null,
    mem_id varchar(20) constraint memid_nn not null,
    mem_pwd varchar(20) constraint mempwd_nn not null,
    mem_name varchar(20) constraint memname_nn not null,
    gender char(3),
    phone varchar(13),
    emain varchar(50),
    constraint mem_uq unique (mem_id)
);

insert into mem_unique5 values(1, 'user01', 'pass01', '강하영', null, null, null);
insert into mem_unique5 values(2, 'user01', 'pass01', '배하영', null, null, null);
insert into mem_unique5 values(3, 'user03', 'pass03', '최하영', 'ㄴ', null, null);


-- 성별이 남, 여 둘 중 하나만 유효한 데이터로 하고 싶을 때
/*
    CHECK(조건식) 제약 조건
        해당 컬럼에 들어올 수 있는 값에 대한 조건을 제시해 둘 수 있음
        해당 조건에 만족한느 데이터값만 입력하도록 할 수 있음
*/

create table mem_check (
    mem_no number not null,
    mem_id varchar2(20) not null,
    mem_pwd varchar2(20) not null,
    mem_name varchar2(20) not null,
    --gender char(3) check ( gender in ('남', '여')) -- 컬럼 레벨 방식
    gender char(3),
    phone varchar2(13),
    email varchar2(50),
    unique (mem_id),
    check (gender in ('남', '여')) -- 테이블 레벨 방식
);

insert into mem_check values(1, 'user01', 'pass01', '강하영', '여', null, null);
insert into mem_check values(2, 'user02', 'pass01', '남궁하영','ㅇ' , null, null);
insert into mem_check values(3, 'user03', 'pass01', '독고하영', null, null, null); -- not null 설정 안 되어 있어서 null 삽입 가능

/*
    PRIMARY KEY (기본키) 제약조건
        테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건 (식별자 역할)
        ex) 회원번호, 학번, 사원번호, 주문번호, 예약번호, 운송장번호 ...
        
    primary key 제약조건을 부여하면 그 컬럼에 자동으로 not null + unique 제약조건을 부여
        >> 대체적으로 검색, 삭제, 수정 등에 기본키의 컬럼값을 이용
        
    ** 주의사항 **
        한 테이블당 오로지 한 개만 설정 가능
*/

create table mem_prikey (
        mem_no number constraint memno_pk primary key, --컬럼 레벨 방식
        mem_id varchar2(20) not null unique,
        mem_pwd varchar2(20) not null,
        mem_name varchar(20) not null,
        gender char(3) check (gender in ('남','여')),
        phone varchar(13),
        email varchar(50)
        -- , primary key (mem_no) -- 테이블 레벨 방식
        -- , constraint memno_pk primary key (mem_no) -- 테이블 레벨 방식으로 이름 넣어주기
);

insert into mem_prikey values(1, 'user01', 'pass01', '강하영', '여', null, null);
insert into mem_prikey values(2, 'user02', 'pass02', '남궁하영', '여', null, null);
insert into mem_prikey values(1, 'user03', 'pass03', '독고하영', '여', null, null); -- 오류

/*
--------------------------------------------------------------------------------------------------------
   
    복합키 
        기본키에 2개 이상의 컬럼을 묶어서 사용
        
        복합키의 사용 예( 한 회원이 어떤 상품을 찜했는지 데이터를 보관하는 테이블)
            회원번호    상품
                1               A
                1               B
                1               A   -- 부적합
                2               A
                2               B
                2               B   -- 부적합
*/

create table tb_like (
        mem_no number,
        product_name varchar2(10), 
        like_date date,
        primary key (mem_no, product_name)
);

insert into tb_like values(1, 'A', sysdate);
insert into tb_like values(1, 'B', sysdate);
insert into tb_like values(1, 'B', sysdate); -- 복합키 오류

--------------------------------------------------------------------------------------------------------
-- 회원 등급에 대한 데이터를 보관하는 테이블

create table mem_grade (
        grade_code number primary key,
        
        grade_name varchar2(20) not null
);

insert into mem_grade values(10, '일반회원');
insert into mem_grade values(20, '우수회원');
insert into mem_grade values(30, '특별회원');

create table mem (
        mem_no number primary key,
        mem_id varchar2(20) not null unique,
        eme_pwd varchar2(20) not null,
        mem_name varchar2(20) not null,
        gender char(3) check (gender in ('남','여')),
        phone varchar2(13),
        email varchar2(50),
        grade_id number         -- 회원등급을 보관할 컬럼
);

insert into mem values(1, 'user01', 'pass01', '강하영', '여', null, null, 10);
insert into mem values(2, 'user02', 'pass02', '남궁하영', '여', null, null, null);
insert into mem values(3, 'user03', 'pass03', '독고하영', '여', null, null, 50);
-- 유효한 회원등급이 아님에도 insert 됨


--------------------------------------------------------------------------------------------------------
/*
    FOREING KEY (외래키) 제약조건
        다른 테이블에 존재하는 값만 들어와야되는 특정 컬럼에 부여하는 제약조건
            => 다른 테이블을 참조한다는 표현
            => 주로 foreing key 제약조건에 의해 테이블 간의 관계가 형성됨
            
            >> 컬럼 레벨 방식
                -- 컬럼명 자료형 REFERENCES 참조할테이블명 (참조할컬럼명)
                     컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명 (참조할컬럼명)
            
            >> 테이블 레벨 방식
                -- FOREING KEY (컬럼명) REFERENCES 참조할테이블명 (참조할컬럼명)
                [CONSTRAINT 제약조건명] FOREING KEY (컬럼명) REFERENCES 참조할테이블명 (참조할컬럼명)
                
            ==> 참조할 컬럼명 생략시 참조할 테이블의 PRIMARY KEY로 지정된 컬럼으로 매칭
*/

create table mem2 (
        mem_no number primary key,
        mem_id varchar2(20) not null unique,
        mem_pwd varchar2(20) not null,
        mem_name varchar2(20) not null,
        gender char(3) check(gender in ('남','여')),
        phone varchar2(13),
        email varchar2(50),
        grade_id number references mem_grade(grade_code) -- 컬럼 레벨 방식
        --grade_id number references mem_grade -- grade_code가 primary key여서 생략 가능
        --grade_id number, 
        --foreing key(grade_id) references mem_grade(grade_code) -- 테이블 레벨 방식 / grade_code가 primary key여서 생략 가능
);

insert into mem2 values(1, 'user01', 'pass01', '배정남', '남', null, null,null);
insert into mem2 values(2, 'user02', 'pass02', '배정여', '여', null, null,30);
insert into mem2 values(3, 'user03', 'pass03', '사과정남', '남', null, null, 70); -- 오류 / 70은 범위에 없음
-- mem_grade (부모테이블) -|--------<-  mem2 (자식테이블) 

--> 이때 부모테이블에서 데이터값을 삭제할 경우 문제가 발생
/*
     - 자식 테이블이 부모의 데이터 값을 사용하지 않고 있으면 삭제 가능
     - 자식 테이블이 부모의 데이터 값을 사용하고 있을 때 문제 발생 -> 삭제 불가
*/

-- mem_grade 테이블에서 30번 삭제\
-- 데이터 삭제: delete from 테이블명; --> 테이블안의 모든 데이터 삭제
-- 데이터 삭제: delete from 테이블명 where 조건; --> 조건에 맞는 행만 삭제

delete from mem_grade where grade_code = 10; --> 삭제됨
delete from mem_grade where grade_code = 30; --> 자식이 사용하고 있어서 삭제 안됨

-- 부모테이블로 부터 부조건 삭제가 안되는 삭제 제한 옵션이 걸려있음 (기본값)

insert into mem_grade values(10, '일반회원');

--------------------------------------------------------------------------------------------------------
/*
    자식 테이블 생성시 외래키 제약조건 부여할 때 삭제 옵션 지정가능
        - 삭제 옵션: 부모테이블의 데이터 삭제시 그 데이터를 사용하고 있는 자식테이블의 값을 어떻게 처리할 지 
        
        >> ON DELETE RESTRICTED (기본값): 삭제 제한 옵션, 자식테이블을 사용하고 있으면 부모테이블의 데이터는 삭제 안됨
        >> ON DELETE SET NULL: 부모 데이터 삭제시 자식 테이블의 값을 NULL로 변경하고 부모 데이터는 삭제
        >> ON DELETE CASCADE: 부모 데이터 삭제시 자식 테이블도 같이 삭제 (행 삭제)
        >> 
*/

create table member2 (
        mem_no number primary key,
        mem_name varchar2(20) not null,
        hobby varchar2(20) default '없음',
        mem_date date default sysdate
);

insert into mem2 values(1, '나원경', '운동', '21/11/15');
insert into mem2 values(2, '나원경', null, null);
insert into mem2 values(3, '나원경', default ,default);

--------------------------------------------------------------------------------------------------------
/*
=====================================skarnddydwls 계정===================================================
    <subquery를 이용한 테이블 생성>
    테이블을 복사하는 개념
    
    [표현식]
    create table 테이블명
    as 서브쿼리;
*/
-- employee 테이블을 복제한 새로운 테이블 생성
create table employee_copy
as select *
from employee;
-- 컬럼, 데이터값 등은 복사
-- 제약조건 같은 경우 not null만 복사됨
-- default, comment는 복사 안됨

-- 데이터는 필요없고, 구조만 복사하고자 할 때
create table employee_copy2
as select emp_id, emp_name, salary, bonus
from employee
where 1=0;

-- 기존 테이블의 구조에 없는 컬럼을 만들때
create table employee_copy3
as select emp_id, emp_name, salary, salary*12 연봉
from employee;
--서브쿼리 select절에 산술식 또는 함수식 기술된 경우 반드시 별칭 지정해야 됨

-----------------------------------------------------------------------------------------
/*
    테이블을 다 생성한 후에 제약조건 추가
    ALTER TABLE 테이블명 변경할내용;
    
        - PRIMARY KEY: ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명)
        - FOREIGN KEY: ALTER TABLE 테이블명 ADD FOREING KEY(컬럼명) REFERENCES 참조할테이블(컬럼명)
        - UNIQUE: ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
        - CHECK: ALTER TABLE 테이블명 ADD CHECK(컬럼에 대한 조건식);
        - NOT NULL: ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;
        - DEFAULT: ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '변경값';
*/

-- employee_copy 테이블 primary key 추가
alter table employee_copy add primary key (emp_id);

-- employee_copy 테이블 dept_code에 외래키 추가(참조: department (dept_id))
alter table employee_copy add FOREIGN KEY(dept_code) references department;

-- employee_copy 테이블 job_code에 외래키 추가(참조: job (job_code))
alter table employee_copy add FOREIGN KEY(job_code) references job;

-- department 테이블 location_id에 외래키 추가 (location 테이블)
alter table department add FOREIGN key (location_id) references location;

-- employee_copy 테이블 ent_yn에 default값 'n' 수정
alter table employee_copy modify ent_yn default 'n';

-- employee copy 테이블에 comment 넣기
comment table on column employee_copy.mem_id is '회원번호';
comment table on column employee_copy.mem_name is '회원명';
comment table on column employee_copy.mem_no is '주민등록번호';

-- 출판사들에 대한 데이터를 담기위한 출판사 테이블
create table publisher (
        pub_no number primary key,
        pub_name varchar2(50) not null,
        phone varchar2(13)
);

insert into publisher values (1, '남 출판사', '010-1234-1234');
insert into publisher values (2, '궁 출판사', '010-9874-9874');
insert into publisher values (3, '용 출판사', '010-9974-1234');

-- 도서들에 대한 데이터를 담기위한 도서 테이블
create table book (
    bk_no number primary key,
    bk_title varchar2(50) not null,
    bk_author varchar2(20) not null,
    bk_price number,
    bk_pub_no number references  publisher on delete cascade
);

INSERT INTO book VALUES (1,'용진의 삶','용진',20000,1);
INSERT INTO book VALUES (2,'궁진의 삶','궁진',20000,1);
INSERT INTO book VALUES (3,'진진의 삶','진진',20000,2);
INSERT INTO book VALUES (4,'박진의 삶','박진',20000,3);
INSERT INTO book VALUES (5,'최진의 삶','최진',20000,2);

-- 회원에 대한 데이터를 담기위한 회원 테이블 
create table member (
    member_no number primary key,
    member_id varchar2(30) unique not null,
    member_pwd varchar2(30) not null,
    member_name varchar2(20) not null,
    gender char(1) check(gender in ('m', 'f')),
    address varchar2(70),
    phone varchar2(13),
    status char(1) default 'n' check(status in ('y','n')),
    enroll_date date default sysdate not null
);

insert into member values (1, 'skarnd01','dydwls', '남궁용진', 'm', null, null, default, default);
insert into member values (2, 'skarnd02','dydwls', '박용진', 'm', null, null, default, default);
insert into member values (3, 'skarnd03','dydwls', '최용진', 'f', null, null, default, default);
insert into member values (4, 'skarnd04','dydwls', '이용진', 'f', null, null, default, default);
insert into member values (5, 'skarnd05','dydwls', '제갈용진', 'm', null, null, default, default);

-- 어떤 회원이 어떤 도서를 대여했ㄴ느지에 대한 대여목록 테이블
create table rent (
    rent_no number primary key,
    rent_mem_no number references member on delete set null,
    rent_book_no number references book on delete set null,
    rent_date date default sysdate
);

insert into rent values (1, 2,1, default);
insert into rent values (2, 5,4, default);
insert into rent values (3, 3,2, default);

-- 1. 계열 정보를 저장할 카테고리 테이블을 만들려고 한다
create table tb_category (
    name varchar2(10),
    use_yn char(1) default 'y'
);

-- 2. 과목 구분을 저장할 테이블을 만들려고 한다
create table tb_class_type (
    no varchar2(5) primary key,
    name varchar2(10)
);

-- 3. tb_category 테이블의 name 컬럼에 primary를 생성
alter table tb_category add primary key (name);

-- 4. tb_class_type 테이블의 name 컬럼에 null 값이 들어가지 않도록 속성을 변경
alter table tb_class_type modify name not null;

-- 5. 두 테이블에서 컬럼명이 no인것은 기존 타입을 유지하면서 크기는 10으로, 컬럼명이 name인것은 마찬가지로
--     기본타입을 유지하면서 크기 20으로 변경하시오 
alter table tb_category modify name varchar2(20);
alter table tb_class_type modify name varchar2(20);
alter table tb_class_type modify no varchar2(10);

-- 6. 두 테이블의 no 컬럼과 name 컬럼의 이름을 각 tb_를 제외한 테이블 이름이 앞에 붙은 형태로 변경
alter table tb_category  rename column name to category_name;
alter table tb_class_type rename column name to class_type_name;
alter table tb_class_type rename column no to class_type_no;

-- 7. tb_category 테이블과 tb_class_type 테이블의 primary key 이름을 pk_ + 컬럼이름 으로 지정
alter table tb_category rename column category_name to pk_category_name;
alter table tb_class_type rename column class_type_no to pk_class_type_no;

-- 8. insert문 실행
insert into tb_category values('공학', 'y');
insert into tb_category values('자연과학', 'y');
insert into tb_category values('의학', 'y');
insert into tb_category values('예체능', 'y');
insert into tb_category values('인문사회', 'y');

-- 9. tb_department의 category 컬럼이 tb_category 테이블의 category_name 컬럼을 부모 값으로 참조하도록 foreign key 지정
--     이 때 key 이름은 fk_테이블이름_컬럼 이름으로 지정
alter table tb_department add foreign key(category) references tb_category;
alter table tb_department rename column category to fk_department_category;




