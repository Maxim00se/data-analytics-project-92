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
ORDER BY s.customer_id;