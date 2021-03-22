use bank;

create view defaultView as
select l.*,
       c.gender as owner,
       1999 - year(c.birthdate) as ownerAge,
       If(c2.clientId is not null, 1,0) as hasDisponent,
       ca.type as creditCard,
       dis.*

from loan l
    join disposition d on l.accountId = d.accountId and d.type = 'OWNER'
        join client c on d.clientId = c.clientId
    left join disposition d2 on l.accountId = d2.accountId and d2.type = 'DISPONENT'
        left join client c2 on d2.clientId = c2.clientId
    left join card ca on d.dispId = ca.dispId
    join account a on a.accountId = l.accountId
        join district dis on dis.districtId = a.districtId
;

select * from defaultView
;

create view transBeforeLoanView as
select t.*
from trans t
join loan l on l.accountId = t.accountId
and t.kSymbol !='UVER'
and t.date < l.date
;

select * from transBeforeLoanView

;