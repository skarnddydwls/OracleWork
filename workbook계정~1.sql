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