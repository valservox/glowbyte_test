/*
В таблице sql_test_personell содержится список сотрудников компании ОАО "Лидер".
Таблица содержит следующие поля:

pers_id                    уникальный номер сотрудника,
department_id              уникальный номер подразделения, в котором работает сотрудник
chief_id                   id руководителя для данного сотрудника
pers_name                  ФИО сотрудника,
pers_salary number         оклад сотрудика в месяц, тыс. руб.
pers_bd date               дата рождения сотрудника
gender                     пол сотрудника

В таблице sql_test_department содержится список отделов компании ОАО "Лидер"

department_id                 идентификатор подразделения,
department_name               наименование подразделения,
department_head               идентификатор сотрудника - главы отдела

В таблице sql_test_address содержится юридический адрес компании, разбитый по столбцам

Задачи:
1. Вывести ФИО всех сотрудников женского пола
2. Вывести ФИО всех сотрудников из отдела продаж
3. Вывести Названия отделов, в которых кол-во сотрудников не превышает 3
4. Вывести ФИО всех сотрудников, которые получают ЗП выше средней по своему отделу
5. Вывести ФИО сотрудников старше 40 лет
6. Необходимо выбрать одного сотрудника для представления ОАО "Лидер" в благотворительном
забеге. Выведите список потенциальных кандидатов, которые соответствуют хотя бы 3-м
любым из нижеперечисленных условий:

1. Руководитель
2. Мужчина
3. Работает в отделе маркетинга
4. Старше 30 лет
5. Имеет оклад выше 70 тысяч руб.
*/

-- 1. Вывести ФИО всех сотрудников женского пола ("F")
select pers_name 
from sql_test_personell 
where gender = "F"
;
-- 2. Вывести ФИО всех сотрудников из отдела продаж ("sales")
select t1.pers_name 
from sql_test_personell t1
join sql_test_department t2 on  t1.department_id = t2.department_id
                            and t2.department_name = "sales"
;
-- 3. Вывести Названия отделов, в которых кол-во сотрудников не превышает 3
with main_select as (
    select 
        t2.department_name, 
        count(t1.pers_id) as pers_qty
    from sql_test_personell t1
    join sql_test_department t2 on t1.department_id = t2.department_id
    group by t2.department_name
    having pers_qty <= 3
)
select department_name from main_select
;
-- 4. Вывести ФИО всех сотрудников, которые получают ЗП выше средней по своему отделу

with main_select as (
    select 
        pers_name,
        pers_salary,
        avg(pers_salary) over (partition by t1.department_id) as department_salary_avg
    from sql_test_personell
    having pers_name > department_salary_avg
)
select pers_name from main_select
;
-- 5. Вывести ФИО сотрудников старше 40 лет

select pers_name from sql_test_personell where months_between(trunc(sysdate),trunc(pers_bd))/12 > 40
;
-- 6. Необходимо выбрать одного сотрудника для представления ОАО "Лидер" в благотворительном
-- забеге. Выведите список потенциальных кандидатов, которые соответствуют хотя бы 3-м
-- любым из нижеперечисленных условий:

-- 1. Руководитель
-- 2. Мужчина ("M")
-- 3. Работает в отделе маркетинга ("marketing")
-- 4. Старше 30 лет
-- 5. Имеет оклад выше 70 тысяч руб.

with main_select as (
    select 
        t1.pers_id,
        max(t1.pers_id = t2.department_head) head_ind,
        max(t1.gender = "M") gen_ind,
        max(t2.department_name = "marketing") dept_ind,
        max(months_between(trunc(sysdate),trunc(pers_bd))/12 > 30) age_ind,
        max(pers_salary > 70000) sal_ind
    from sql_test_personell t1
    left join sql_test_department t2 on t1.department_id = t2.department_id
    group by t1.pers_id
    having head_ind + gen_ind + dept_ind + age_ind + sal_ind >= 3
)
select pers_id where rownum = 1
;