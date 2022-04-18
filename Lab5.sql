select customer_name,customer_street,customer_city 
from customer natural join depositor natural join 
account natural join branch 
where branch.branch_city= customer.customer_city ;


select customer_name,customer_street,customer_city 
from (select customer_name,customer_street,customer_city 
        from customer natural join depositor natural join 
        account natural join branch 
         where branch.branch_city= customer.customer_city
        );
                  
                  
                  
select customer_name,customer_street,customer_city 
from customer natural join borrower 
natural join loan 
natural join branch 
where branch.branch_city= customer.customer_city;


select customer_name,customer_street,customer_city 
FROM (select customer_name,customer_street,customer_city 
        from customer natural join borrower 
        natural join loan 
        natural join branch 
        where branch.branch_city= customer.customer_city 
        );
        

SELECT b.branch_city,avg(a.balance)
FROM account a,branch b,(SELECT b.branch_city as branch_city2,
                        avg(a.balance) as avg_bal 
                        FROM account a,branch b 
                        WHERE b.branch_name = a.branch_name 
                        group by b.branch_city) c
WHERE b.branch_name = a.branch_name and c.branch_city2=b.branch_city 
and c.avg_bal>=1000 GROUP BY b.branch_city;

SELECT branch_city,avg(balance)
FROM account natural join branch 
GROUP BY branch_city
HAVING avg(balance)>=1000;


SELECT b.branch_city,avg(l.amount)
FROM loan l,branch b,(SELECT b.branch_city as branch_city2,
                       avg(l.amount) as avg_bal 
                     FROM loan l,branch b 
		             WHERE b.branch_name = l.branch_name 
                     group by b.branch_city) c
WHERE b.branch_name = l.branch_name and c.branch_city2=b.branch_city 
and c.avg_bal>=1500 GROUP BY b.branch_city;


SELECT branch_city,avg(amount)
FROM loan natural join branch 
GROUP BY branch_city
HAVING avg(amount)>=1500;


select customer_name,customer_street,customer_city 
        from customer natural join depositor natural join account 
        where account.balance IN (select max(balance) from account );
        
        
select customer_name,customer_street,customer_city 
        from customer natural join depositor natural join account 
        where account.balance >= ALL(select max(balance) from account);
        
        
select customer_name,customer_street,customer_city 
        from customer natural join borrower natural join loan 
        where loan.amount IN (select min(amount) from loan );
        
        
select customer_name,customer_street,customer_city 
        from customer natural join borrower natural join loan 
        where amount <= ALL(select amount from loan);
        


select distinct branch_name,branch_city 
    from (select * from branch natural join account) t1 
    where (branch_name,branch_city) in 
    (select branch_name,branch_city
    from (select * from branch natural join loan )t2 
    where t1.branch_name=t2.branch_name);


select DISTINCT branch_name, branch_city
    from (select * from branch natural join account) t1
    where EXISTS (select branch_name, branch_city
    from (select * from branch natural join loan) t2
    where t1.branch_name=t2.branch_name);
    
    
select distinct customer_name,customer_city 
    from customer natural join depositor 
    where (customer_name,customer_city) not in 
    (select customer_name,customer_city from customer natural join borrower);
    
    
select distinct customer_name,customer_city 
    from (select * from customer natural join depositor) t1 where not exists 
    (select customer_name,customer_city  from 
    (select * from customer natural join borrower )t2
    where t1.customer_name=t2.customer_name) ;
    
    
    
    
select branch_name 
from branch NATURAL JOIN account,(select sum(balance) 
as sum_bal from branch NATURAL JOIN account)TEMP1,(select avg(balance)
as avg_bal from branch NATURAL JOIN account)TEMP
where TEMP1.sum_bal>TEMP.avg_bal;


WITH TEMP(avg_bal) as 
(select avg(balance)
from branch NATURAL JOIN account),
TEMP1(sum_bal) as 
(select sum(balance)
from branch NATURAL JOIN account)
select branch_name
from branch NATURAL JOIN account,TEMP,TEMP1
where TEMP1.sum_bal>TEMP.avg_bal; 


select branch_name 
from branch NATURAL JOIN loan,(select sum(amount) 
as sum_amo from branch NATURAL JOIN loan)TEMP1,(select avg(amount)
as avg_amo from branch NATURAL JOIN loan)TEMP
where TEMP1.sum_amo<TEMP.avg_amo;


WITH TEMP(avg_amo) as 
(select avg(amount)
from branch NATURAL JOIN loan),
TEMP1(sum_amo) as 
(select sum(amount)
from branch NATURAL JOIN loan)
select branch_name
from branch NATURAL JOIN loan,TEMP,TEMP1
where TEMP1.sum_amo<TEMP.avg_amo; 



