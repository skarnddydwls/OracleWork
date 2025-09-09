/*
        ALTER
            객체를 변경하는 구문
            
            [표현식]
            ALTER TABLE 테이블명 변경할내용;
            
        - 변경할 내용
            1. 컬럼 추가/수정/삭제
            2. 제약조건 추가/삭제 (수정 불가 -> 삭제하고 다시 새로 추가)
            3. 컬럼명/제약조건명/테이블명 변경
*/
--------------------------------------------------------------------------------
/*
        1. 컬럼 추가/수정/삭제
            1) 컬럼 추가 ADD
            
            [표현법]
            ADD 컬럼명 데이터타입 [DEFAULT 기본값]
*/
-- dept_copy 테이블에 cname(varchar2(20)) 컬럼 추가
alter table dept_copy add cname varchar2(20);
--> 새로운 컬럼이 만들어지고 기본적으로 null로 채워짐

-- dept_copy 테이블에 lname(varchar2(20)) default는 한국으로 컬럼 추가
alter table dept_copy add lname varchar2(20) default '한국';
--> 새로운 컬럼이 만들어지고 
--------------------------------------------------------------------------------
/*
        2) 컬럼의 이름 또는 데이터타입 수정 (MODIFY)
        
        [표현법]
            - 데이터타입 수정
                MODIFY 컬럼명 바꾸고자하는 데이터타입
            
            - DEFAULT값 수정
                MODIFY 컬럼명 DEFAULT 바꾸고자하는 기본값
*/
-- dept_copy 테이블의 dept_id의 데이터타입을 char(3)으로 변경
alter table dept_copy modify dept_id char(3);

-- dept_copy 테이블의 dept_id의 데이터탕비을 number로 변경
alter table dept_copy modify dept_id number;
--> 오류: 컬럼에 영문이 있음. 또한 컬럼의 데이터 타입을 변경할 땐 해당 컬럼의 값을 모두 지워야 변경 가능

-- detp_copy 테이블의 detp_title의 데이터의 byte를 10byte로 변경
alter table dept_copy modify dept_title varchar(40);
--> 오류: 컬럼의 데이터값이 10byte가 넘는 데이터가 존재

-- dept_copy 테이블의 dept_title 컬럼을 varchar2(40)으로 변경
-- dept_copy 테이블의 location_id 컬럼을 varchar2(2)으로 변경
-- dept_copy 테이블의 lname의 default값을 '미국'으로 변경

-- 다중 변경 가능
alter table dept_copy -- ' , ' 찍는거 아님
    modify dept_title varchar2(40)
    modify location_id varchar(2)
    modify lname default '미국';

--------------------------------------------------------------------------------
/*
        3. 컬럼 삭제
        
        [표현법]
        DROP COLUMN 컬럼명
*/

create table dept_copy2
as select * from dept_copy;

-- dept_copy2 테이블에서 dept_id 컬럼 삭제
alter table dept_copy2 drop column dept_id;

-- dept_copy2 테이블에서 dept_title 컬럼 삭제
-- 컬럼 삭제는 다중 삭제 안됨
alter table dept_copy2 drop column dept_title;
alter table dept_copy2 drop column location_id;
alter table dept_copy2 drop column cname;
alter table dept_copy2 drop column lname; -- 한 개의 컬럼은 반드시 남아있어야 됨

--------------------------------------------------------------------------------
/*
        2. 제약조건 추가/삭제
            1)  제약조건 추가
                alter table 테이블명 추가(변경)할 내용
                        - primary key: alter table 테이블명 add primary key (컬럼명)
                        - foreign key: alter table 테이블명 add foreign key (컬럼명) references 참조할테이블명 [(참조할컬럼명)]
                        - unique: alter table 테이블명 add unique (컬럼명)
                        - check: alter table 테이블명 add check (컬럼에대한 조건식)
                        - not null: alter table 테이블명 modify 컬럼명 not null
                        
                    --> 제약조건명을 지정하려면: constraint 제약조건명 제약조건
             2) 제약조건 삭제
                drop constraint 제약조건
                modify 컬럼명 null | not null
*/
-- dept_copy 테이블에서 dept_id에 primary key 제약조건 추가
-- dept_copy 테이블에서 dept_title의 값이 유일한 값이여야하는 제약조건 추가
-- dept_copy 테이블에서 lname의 값이 null을 가질 수 없다는 제약조건 추가

alter table dept_copy 
add constraint dcopy_pk primary key (dept_id)
add constraint dcopy_iq unique (dept_title)
modify lname not null;
        
-- 제약조건 dcopy_pk 삭제
alter table dept_copy drop constraint dcopy_pk;

alter table dept_copy modify lname null; -- null | not null은 drop이 아니라 modify

--------------------------------------------------------------------------------
/*
        3. 컬럼명/제약조건명/테이블명 변경
            1) 컬럼명 변경
                [표현식]
                rename column 기존컬럼명 to 바꿀컬럼명
*/
-- dept_copy 테이블의 dept_title을 dept_name으로 변경
alter table dept_copy rename column dept_title to dept_name;

--------------------------------------------------------------------------------
/*
            2) 제약조건명 변경
                [표현식]
                rename constraint 기존제약조건명 to 변경할제약조건명
*/
-- dept_copy 테이블의 dcopy_uq 제약조건명을 dcopy_unique로 변경
alter table dept_copy rename constraint dcopy_uq to dcopy_unique;

--------------------------------------------------------------------------------
/*
            3) 테이블명 변경
                [표현식]
                rename [기존테이블명] to 바꿀테이블명
*/
alter table dept_copy rename to dept_change; 

--------------------------------------------------------------------------------
/*
        4. 테이블 삭제
*/
drop table dept_change;

/*
        ** 테이블 삭제시 외래키의 부모테이블은 삭제 안됨 ** 
            방법 1) 자식 테이블 먼저 삭제한 후 부모 테이블 삭제
            방법 2) 부모테이블만 삭제하는데, 제약조건을 같이 삭제 
                        drop table 부모테이블명 cascade constraint; 
*/