-- COMP3311 19T3 Assignment 3
-- Helper views and functions (if needed)

-- helper views for q1
create or replace view q1_course_count as
select course_id, count(*) from course_enrolments group by course_id;
create or replace view q1 as
select s.code, cc.count, c.quota from q1_course_count as cc, courses as c, subjects as s, terms as t 
where c.id = cc.course_id and c.subject_id = s.id and cc.count > c.quota and c.term_id = t.id
and t.name='19T3' and c.quota > 50;


-- helper views for q2
create or replace view q2_num as select substring(code, 5, 4) as num, substring(code, 1, 4) as str from subjects;
create or replace view q2 as select num, count(*), string_agg(str, ' ' order by str) from q2_num group by num;

-- helper views for q3
create or replace view q3_building_room as 
select b.id as building_id, r.id as room_id, b.name from buildings as b, rooms as r where b.id = r.within;
create or replace view q3_subject_room as 
select s.code, c.id as course_id, m.room_id from subjects as s, courses as c, meetings as m, classes as cl, terms as t  
where s.id = c.subject_id and cl.course_id = c.id and cl.id = m.class_id and c.term_id = t.id and t.name = '19T2';
create or replace view q3 as 
select b.name, s.code, substring(s.code, 1, 4) as str from q3_building_room as b, q3_subject_room as s 
where b.room_id = s.room_id order by b.name;

--helper views for q4
create or replace view q4_code_term as 
select c.id, s.code ,t.name, substring(s.code, 1, 4) as str from subjects as s, terms as t, courses as c 
where t.id = c.term_id and c.subject_id = s.id;
create or replace view q4_course_count as 
select c.id, count(*) from courses as c, course_enrolments as e 
where e.course_id = c.id group by c.id;
create or replace view q4 as 
select ct.code, ct.name, ct.str, cc.count from q4_code_term as ct, q4_course_count as cc 
where ct.id = cc.id;

--helper views for q5
create or replace view q5_term_course as 
select c.id, s.code from courses as c, subjects as s, terms as t  
where t.name = '19T3' and t.id = c.term_id and c.subject_id = s.id;
create or replace view q5_class_count as 
select c.id, c.tag, c.quota, count(*), c.course_id, t.name as type_name from classes as c, class_enrolments as e, classTypes as t 
where e.class_id = c.id and c.type_id = t.id group by c.id, t.name;
create or replace view q5 as 
select tc.code, cc.tag, cc.type_name, cc.quota, cc.count from q5_term_course as tc, q5_class_count as cc 
where tc.id = cc.course_id and cc.count < 0.5*cc.quota group by tc.code, cc.tag, cc.quota, cc.count, cc.type_name;