
-- (a)
select count(*) as TOTAL from (select distinct e.employeeNumber from customers c
join employees e on e.employeeNumber = c.salesRepEmployeeNumber]
order by e.employeeNumber) t;

-- (b)
