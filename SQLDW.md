
1. Create DW

1. Load data into SQL DW

    1. Log into SQL DW from Cloud Shell

    ```sql
    sqlcmd -S azsql123dhw.database.windows.net -d master -U sqladmin -P 1q2w3e4R -I
    ```

    1. Create Key
    
    Create a master key for the SampleDW database

    ```sql
    CREATE MASTER KEY;
    GO
    ```

    1. 

    ```sql
    CREATE EXTERNAL DATA SOURCE WWIStorage WITH ( TYPE = Hadoop, LOCATION = 'wasbs://wideworldimporters@sqldwholdata.blob.core.windows.net');
    ```

    1. 

    ```sql
    CREATE EXTERNAL FILE FORMAT TextFileFormat WITH ( FORMAT_TYPE = DELIMITEDTEXT, FORMAT_OPTIONS (FIELD_TERMINATOR = '|', USE_TYPE_DEFAULT = FALSE) );
    ```

    1. 

    ```sql
    CREATE SCHEMA ext; 
    go
    ```

    ```sql
    CREATE SCHEMA wwi; 
    go
    ```

    ```bash
    sqlcmd -S azsql123dhw.database.windows.net -d wwidw -U sqladmin -P 1q2w3e4R -I -i ./createSQLDWtables.sql
    ```

[Lab document](https://docs.microsoft.com/en-us/azure/sql-data-warehouse/load-data-wideworldimportersdw)