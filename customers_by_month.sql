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