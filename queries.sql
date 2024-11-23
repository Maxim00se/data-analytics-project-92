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


/*
 *Данный запрос считает кол-во покупателей каждой возрастной группы. 
 *С помощью оператора CASE мы создаем условие и название категории, затем идет подсчет и
 *распределение по группам.
 */
SELECT
    CASE
        WHEN age BETWEEN 16 AND 25 THEN '16-25'
        WHEN age BETWEEN 26 AND 40 THEN '26-40'
        ELSE '40+'
    END AS age_category,
    COUNT(*) AS age_count
FROM customers c 
GROUP BY age_category
ORDER BY age_category


/*
 * Данный запрос считает кол-во уникальных покупателей и их выручку за определенный месяц.
 */
select
	to_char(s.sale_date, 'YYYY-MM') as date,
	count(distinct s.customer_id) as total_customers,
	floor(SUM(s.quantity * p.price)) as income
from sales s
left join products p on s.product_id = p.product_id
group by date
order by date


/*
 * Данный запрос выводит покупателей, чья первая покупка пришлась на акционный товар с ценой = 0.
 * Также была выведена дата покупки и имя продавца.
 */
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer, 
    MIN(s.sale_date) AS sale_date,
    CONCAT(e.first_name, ' ', e.last_name) AS seller
FROM sales s
LEFT JOIN products p ON s.product_id = p.product_id
LEFT JOIN customers c ON s.customer_id = c.customer_id
LEFT JOIN employees e ON s.sales_person_id = e.employee_id
WHERE p.price = 0
GROUP BY s.customer_id, c.first_name, c.last_name, e.first_name, e.last_name
ORDER BY s.customer_id