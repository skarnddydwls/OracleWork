-- 1.
select department_name "학과 명",  category 계열
from tb_department;

-- 2.
select department_name ,'의 정원은',capacity "학과별 정원",' 명 입니다'
from tb_department;

-- 3.
select student_name
from tb_student
where student_no in ('A513079', 'A513090','A513091','A513110','A513119')
order by student_name desc;

-- 4.
select department_name, category
from tb_department
where capacity between 20 and 30;

-- 5.
select professor_name
from tb_professor
where department_no is null;

-- 6.
select student_name
from tb_student
where department_no is null;

-- 7.
select class_no
from tb_class
where preattending_class_no is not null;

-- 8.
select distinct category
from tb_department
order by category;

-- 9.
SELECT student_no, student_name, student_ssn
from tb_student
where absence_yn = 'N' and  entrance_date = '02/03/01' and student_address like '전주시%';

-- 1.
insert into tb_class_type values(01, '전공필수'), (02,'전공선택'), (03, '교양필수'), (04, '교양선택'), (05,'논문지도');

-- 2.
create table tb_student_information
as select student_no, student_name, student_address
from tb_student;

-- 3.  check
create table tb_국어국문학과
as select student_no 학번
, student_name 학생이름 
, extract(year from to_date(substr(student_ssn,1, 2), 'RRRR')) 출생년도 -- 'RRRR' 포멧 형식 넣어야 됨
, nvl(professor_name, '지도교수 없음') 교수명
--substr(to_char(student_ssn),1,2) 주민번호
    from tb_student s
    left join tb_professor on (coach_professor_no = professor_no)
    left join tb_department d on (s.department_no = d.department_no)  -- using 사용법 
    where department_name = '국어국문학과';

drop table tb_국어국문학과;

-- 4.
update tb_department
set capacity = capacity * 1.1;

-- 5.
update tb_student
set student_address = '서울시 종로구 숭인동 181-21'
where student_no = 'A413042';

-- 6.
update tb_student
set student_ssn = substr(to_char(student_ssn),1,6);

-- 7.
select class_no, class_name
from tb_class
where class_name = '피부생리학'; -- C3843900

select student_no, student_name, department_no
from tb_student
where student_name = '김명훈'; -- A331101

select department_name, department_no
from tb_department
where department_name = '의학과';

update tb_grade
set point = 3.5
where student_no = 'A331101' and class_no = 'C3843900';

select student_no, class_no, point
from tb_grade
where student_no = 'A331101' and class_no = 'C3843900';

rollback;
-- 8.
-- 서브쿼리
select student_no
from tb_student
where absence_yn = 'Y';

delete from tb_grade
where student_no in (select student_no
            from tb_student
            where absence_yn = 'Y');
            
rollback;