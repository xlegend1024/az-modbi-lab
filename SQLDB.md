
1. Create DB

1. Restore DB (Import DB)

Select bacpac file from a Blob storage 

Select P1 (125 DTU), import will take 5 minutes

If you see an test connection error, please check firewall rule.

1. Replicate DB (for read only)

    1. Create a new SQL Server in another region 

    1. Config failover region

    1. Config failover group

    1. Create new table and insert sample data

```sql
CREATE TABLE dbo.Employee (EmployeeID int PRIMARY KEY CLUSTERED, EmpName varchar(20));
INSERT INTO dbo.Employee VALUES (1, "Hyun");
INSERT INTO dbo.Employee VALUES (2, "Arthur");
INSERT INTO dbo.Employee VALUES (3, "Jack");
```

1. Backup 

1. Copy Database

1. 

