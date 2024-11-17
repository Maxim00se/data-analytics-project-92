/*
 *Данный запрос считает кол-во покупателей 
 */
select
	count(customer_id) as customers_count
from customers;


/*
 *Данный запрос выводит топ 10 лучших сотрудников по объемам продаж:
 *1. Считается общее кол-во проданных товаров
 *2. Суммирутеся выручка
 *3. С помощью Group by мы группируем выручку и кол-во проданных товаров по сотрудникам  
 */
select
	concat(e.first_name, ' ', e.last_name) as seller,
	sum(s.quantity) as operations,
	floor(sum(s.quantity * p.price)) as income
from sales s
left join employees e on s.sales_person_id = e.employee_id
left join products p on s.product_id = p.product_id
group by seller
order by income desc
limit 10


/*
 *Данный запрос выводит продавцов, чья выручка ниже средней выручки всех продавцов.
 *1. В СТЕ avg_income_all считается средняя выручка всех продавцов.
 *2. Далее, считается средняя выручка каждого продавца average_income.
 *3. В having сравниваются значения, если выручка продавца меньше, чем средняя выручка
 *всех продавцов, то он выводится в таблицу  
 */
with avg_income_all as (
	select
		floor((sum(s.quantity * p.price)) / sum(s.quantity)) as avg_income_all
	from sales s
	left join products p on s.product_id = p.product_id
)
select
	concat(e.first_name, ' ', e.last_name) as seller,
	floor(sum(s.quantity * p.price) / sum(s.quantity)) as average_income
from sales s
left join employees e on s.sales_person_id = e.employee_id
left join products p on s.product_id = p.product_id
group by seller
having floor(sum(s.quantity * p.price) / sum(s.quantity)) < (select avg_income_all from avg_income_all)


/*
 *Данный запрос выводит данные по выручке по каждому продавцу и дню недели.
 *1. Считается выручка каждого продавца, группирутеся по дням недели.
 *В поле order by ((to_char(s.sale_date, 'D')::INTEGER + 5) % 7) GPT подсказал как сдвинуть день недели, 
 *чтобы таблица начиналась с понедельника. Изначально отсчет шел с воскресенья. 
 */
select
	concat(e.first_name, ' ', e.last_name) as seller,
	trim(to_char(s.sale_date, 'Day')) AS day_of_week,
	floor(sum(s.quantity * p.price)) as income
from sales s 
left join employees e on e.employee_id = s.sales_person_id
left join products p on p.product_id = s.product_id
group by seller, day_of_week, to_char(s.sale_date, 'D')
order by (to_char(s.sale_date, 'D')::INTEGER + 5) % 7, seller asc 
order by average_income