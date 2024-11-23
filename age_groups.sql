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