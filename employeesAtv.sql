
-- (a)
select count(*) as TOTAL from (select distinct em.employeeNumber from customers cs
join employees as em on em.employeeNumber = cs.salesRepEmployeeNumber
order by em.employeeNumber) t;

-- (b)
select cs.customerNumber, cs.customerName, count(*) as TOTAL from orders as od
inner join customers as cs ON cs.customerNumber = od.customerNumber
group by cs.customerNumber;

-- (c)
select cs.customerNumber, cs.customerName, avg(od.customerNumber) from customers as cs
inner join orders as od on cs.customerNumber = od.customerNumber 
group by cs.customerNumber;

-- (d)
select oc.officeCode, oc.addressLine1 , count(em.employeeNumber) from offices as oc
inner join employees as em on oc.officeCode = em.officeCode 
group by oc.officeCode;

-- (e)
select em.employeeNumber, em.firstName, em.lastName, count(od.customerNumber) as TOTAL_VENDAS from employees as em
inner join customers as cs on em.employeeNumber = cs.salesrepemployeeNumber 
inner join orders as od on cs.customerNumber = od.customerNumber 
group by em.employeeNumber;


