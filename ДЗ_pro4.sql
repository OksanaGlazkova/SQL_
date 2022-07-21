
with cte as (
	select payment_id, postal_code, city, district, address, amount, date_trunc('week', payment_date), sum(amount) over (partition by 'date_trunc', date_trunc('week', p.payment_date)) as sum_week_payment,
date_trunc('month', p.payment_date), sum(amount) over (partition by 'date_trunc', date_trunc('month', p.payment_date)) as sum_month_payment
	from payment p
	left join staff s using (staff_id)
	left join store s2 on s.store_id = s2.store_id
	left join address a on s2.address_id = a.address_id
	left join city c2 on a.city_id = c2.city_id)
select p.payment_id, p.payment_date, a.postal_code, c2.city, a.district, a.address, f.title, f.description, f.release_year, f.rental_rate, f.length, f.replacement_cost,
cte.postal_code as postal_code_store, cte.city as city_store, cte.district as district_store, cte.address as address_store,
sum_week_payment, sum_month_payment,
s.first_name as first_name_staff, s.last_name as last_name_staff
from payment p
left join cte using (payment_id)
left join staff s using (staff_id)
left join customer c using (customer_id)
left join address a on c.address_id = a.address_id
left join city c2 on a.city_id = c2.city_id
left join rental r on p.rental_id = r.rental_id
left join inventory i on r.inventory_id = i.inventory_id
left join film f on i.film_id = f.film_id

