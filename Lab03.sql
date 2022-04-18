select branch_name, branch_city from branch 
where assets>1000000;

select account_number, balance from account
where branch_name = 'Downtown' or (balance>600 and balance<750);

