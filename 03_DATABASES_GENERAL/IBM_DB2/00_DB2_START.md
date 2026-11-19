# IBM DB2

## Brief History of DB2 aqnd its Relation to Informix

- ***1970s-1980s***: DB2 is the birthplace of the relational DB. In 1970, IBM researcher Edgar F. **Codd** published the **relational model theory**, which led IBM's San Jose Research Laboratory to build **System R** and invent **SQL** (originally *SEQUEL*). IBM released **IBM Database 2** (DB2) commercially for mainframes (MVS) in **1983**, and later ported the codebase to distributed platforms - **DB2 LUW** (**L**inux, **U**NIX, **W**indows) in 1993, which is actually the version running on **AIX**.

- **Relation to IBM Informix**: Throughout the 1990s, **Informix** Software was one of IBM's fiercest competitors in UNIX enterprise databases (alongside **Oracle** and **Sybase**). In July **2001**, **IBM acquired Informix**'s database business for $1 billion USD.

- **How they coexist today**: Rather than merging the two engines into one, IBM kept both products alive under its data management portfolio. **Informix** remained prized for **ultra-low-maintenance** **OLTP**, embedded systems, and time-series workloads, while **DB2** became IBM's flagship heavy-duty enterprise RDBMS for banking, core systems and analytics.
Because they come from completely separate codebases, their **SQL dialects**, **system catalogs** and **CLI tools** remain **distinct**, though IBM has cross-pollinated certain features over the years.

## Connecting to DB2 from an AIX CLI Tool

Unlike Informix's interactive menu-driven `dbacess`, DB2 uses the **DB2 Command Line Processor (CLP)**, invoked simply with the `db2` command.

Before running `db2`, your AIX shell environment must load the DB2 instance profile (usually already configured in your `.profile`, or sourced via `. ~/sqllib/db2profile`).

### Mode A: Interactive CLP Shell (Closest to `dbacess`)

```bash
$ db2
db2 => connect to <dbname>
# Or, if authenticating explicitly:
db2 => connect to <dbname> user <username> using <psw>
```

\* In interactive mode, commands do not end with a semicolon by default unless you launch it with `db2 -t` (**highly recommended** so multi-line queries work cleanly).

\* To exit, type `quit` (this leaves the background connection alive) or `terminate` to drop the connection and kill the background CLP process. (Always use `terminate` when finishing up).

### Mode B: Direct Shell Execution (Great for AIX scripting/quick checks)

You can run commands directly from the AIX bash/ksh prompt without entering interactive mode. Notice that the connection persists across commands in your current shell session.

```bash
db2 "connect to <dbname> user <username> using <password>"
db2 "SELECT COUNT(*) FROM my_schema.my_table"
db2 "terminate"
```

### Mode C: Running a script.sql File (equivalent to `dbaccess dbname script.sql`)

```bash
# -t = enforce semicolon delimiter
# -v = verbose (I love verbose commands <3)
# -f = file
db2 -tvf script.sql
```

# Essential Commands & Syntax: DB2 vs Informix

## CLI & Metadata Inspection

In Informix, you query `systables` or use `dbschema`. In DB2, you have built-in CLP shortcuts as well as `SYSCAT` catalog views.

| Task   |   Informix (`dbaccess`/`dbschema`)    | DB2 CLP / SQL (`-t`)  |
| :---   | :---          |   :---          |
| List user tables       | `SELECT tabname FROM systables WHERE tabid > 99;`       | `LIST TABLES;` (current schema) or `LIST TABLES FOR ALL;`    |
| Describe table structure | `INFO COLUMNS FOR table_name;` | `DESCRIBE TABLE schema.table_name;` |
| Describe query output | (Inspect target table) | `DESCRIBE SELECT * FROM schema.table_name;` |
| Extract DDL | `dbschema -d dbname -t tabname` | `db2look -d dbname -e -t tabname` (from AIX shell) |
| Check current DB/User | `SELECT DBINFO('dbname'), USER FROM systables WHERE tabid=1;` | `VALUES CURRENT SERVER, CURRENT USER;` |
| Dummy table for Expressions | `SELECT TODAY FROM systables WHERE tabid=1;` | `VALUES CURRENT DATE` or `SELECT 1 FROM SYSIBM.SYSDUMMY1;`  |

## SQL Dialect & Querying Differences

| Feature   |   Informix SQL | DB2 SQL  |
| :---   | :---          |   :---          |
| Limit rows returned | `SELECT FIRST 10 * FROM table;` | `SELECT * FROM table FETCH FIRST 10 ROWS ONLY;` |
| Row numbering/pagination | `SELECT SKIP 20 FIRST 10 * FROM table;` | `SELECT * FROM table OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY;` |
| Current Date/Timestamp | `TODAY`/`CURRENT YEAR TO SECOND;` | `CURRENT DATE` / `CURRENT TIMESTAMP` |
| Date Arithmetic | `TODAY - 7 UNITS DAY` | `CURRENT DATE - 7 DAYS` |
| Null Coalescing | `NVL(col, 'default')` | `COALESCE(col, 'default')` |
| String concatenation | `col1 \|\| col2` | `col1 \|\| col2` |
| Case-insesntive match | `col MATCHES '*abc*'` or `ILIKE` | `UPPER(col) LIKE '%ABC%'` |
| Isolation / Dirty Read | `SET ISOLATION TO DIRTY READ;` | Append `WITH UR` (Uncommitted Read) to the end of a `SELECT` |
| Lock wait timeout | `SET LOCK MODE TO WAIT 5;` | `SET CURRENT LOCK TIMEOUT 5;` |