# Informix Transactions

Informix handles transactions explicitly using the `WORK` keyword. In a **logged database** (which any banking environment will use), **every DML operation outside** of an explicit transaction is treated as an **auto-committed transaction**.

```sql
CREATE PROCEDURE "informix".sp_transfer_funds (
    from_acct INT,
    to_acct INT,
    amount DECIMAL(10,2)
)
    -- 1. Start the Transaction
    BEGIN WORK;

    UPDATE tbl_accounts
    SET balance = balance - amount
    WHERE acct_id = from_acct;

    UPDATE tbl_accounts
    SET balance = balance + amount
    WHERE acct_id = to_account;

    -- 2. Evaluate conditions to COMMIT or ROLLBACK
    IF amount <= 0 THEN
        ROLLBACK WORK;
    ELSE
        COMMIT WORK;
    END IF;
END PROCEDURE;
```

## The Concurrency Controls: Isolation and Locking

In high-volume banking databases, **lock contention** is the most common cause of performance degradation and query failure. The two following statements control how your session interacts with locks held by other sessions.

### `SET ISOLATION TO DIRTY READ;`

This statement instructs the database engine to **ignore all row, page and table locks** when reading data, and it does not place **any shared locks** of its own.

- **What this implies**: Your query will return data **immediately**, even if **another transaction is currently updating** that row but hasn't committed yet.
- **The risk**: you might read a balance of $500, but if the other transaction rolls back, those $500 never actually existed.
- **Banking Use Case**: It is strictly used for *reporting*, *batch extracts* or *checking non-critical status* where **absolute precision** at the millisecond is **not required**, and blocking the application is unacceptable. **Never use this for calculating debits/credits**.

### `SET LOCK MODE TO WAIT 3;`

By default, if Informix tries to **read** or **update** a row that is locked by another user, it immediately throws an error (`-244: Could not do a locking operation`).

- **What this sentence implies**: this command tells the database: "If you hit a lock, do not fail immediately. Wait up to 3 seconds for the other transaction to release the lock. If 3 seconds pass and it is still locked, then throw the error".

- **Banking Use Case**: This is the standard survival mechanism for heavily hit tables (like `tbl_account` or `tbl_ledger`). It prevents **transient locks** (lasting a few milliseconds) from instantly failing your stored procedure.

# Exception Handling Scope in SPL

Informix SPL traps errors using the `ON EXCEPTION` block.

**Scope Rule** ---> An `ON EXCEPTION` block applies **only to the statements that follow it** *within the same statement block* (e.g., between `BEGIN` and `END`, or within a loop), and it **overrides any previously defined exception handler** for those specific errors.

```sql
CREATE PROCEDURE "informix".safe_update()
    DEFINE v_err_ INT;
    DEFINE v_isam INT;

    -- This handler catches ALL errors (because there is no specifin IN (...))
    ON EXCEPTION SET v_err, v_isam
        -- If an error occurs below, EXECUTION JUMPS HERE:
        ROLLBACK WORK;
        -- You can raise a custom error to the Java backend using "RAISE EXCEPTION"
        RAISE EXCEPTION -746, 0, "Transaction Failed due to lock timeout";
    END EXCEPTION;

    BEGIN WORK;
    -- Informix will wait 3 seconds before throwing a "-244: lock error"
    SET LOCK MODE TO WAIT 3;
    -- Ahora sí, van los DML:
    UPDATE tbl_ledger
    SET status = 'PROCESSED'
    WHERE status = 'PENDING';
    -- If for some reason an error is thrown, the COMMIT will NOT be executed. Instead, the ROLLBACK WORK will be executed.
    COMMIT WORK;
END PROCEDURE;
```

## `END EXCEPTION WITH RESUME;`

```sql
ON EXCEPTION SET v_err, v_isam
    ROLLBACK WORK;
    RAISE EXCEPTION -746, 0, "Transaction failed due to lock timeout";
END EXCEPTION WITH RESUME;
```

With that last `WITH RESUME;`, Informix will execute the handler block and then jump back to the EXACT line after the one that failed, **continuing execution**.

# Transactional Errors (`-255` and `-535`)

<u>**Summary**</u>:

1. `-255: Not in Transaction` (`COMMIT;` or `ROLLBACK;` without `BEGIN WORK`;)
2. `-535: Already in Transaction` (`BEGIN WORK;` ... `BEGIN WORK;`).

Informix tracks transaction states meticulously. When you get transactional errors, it usually means the logical flow of your SPL `BEGIN > COMMIT/ROLLBACK` statements got misaligned, often due to **unhandled exceptions jumping over a `COMMIT`**.

## `-255: Not In Transaction`

**Why it happens in SPL**:
1. You attempted to execute `COMMIT WORK;` or `ROLLBACK WORK;`, but there is no active transaction.
You already committed/rolled back earlier in the execution path, and hit a second `COMMIT/ROLLBACK WORK;`.
2. You called a stored procedure that issued a `BEGIN WORK;`, but **failed** and **rolled back internally**, and then the parent procedure tried to commit.
3. The DB was created **without transaction logging** (rare in modern systems, but possible in **legacy scratchpad databases**).

## `-535: Already in Transaction`

**Why it happens in SPL**:
1. You attempted to execute `BEGIN WORK;` but a transaction was already open. Informix does **not** support **nested transactions** using `BEGIN WORK;`. You cannot start a transaction inside a transaction.

2. If a Java application opens a JDBC transaction (e.g. Spring's `@Transactional`) and then calls an Informix Stored Procedure that explicitly contains `BEGIN WORK;`, Informix will throw an `-535` error. 

3. To handle partial rollbacks within an active transaction, you must use savepoints (`SAVEPOINT sp1;` and `ROLLBACK WORK TO SAVEPOINT sp1;`) instead of nested `BEGIN WORK;` commands.

# Transactional SP that handles 255 and 535

Spring often manages transactions via the `@Transactional` annotation, meaning, by the time the SP is called, a transaction might already be open.

Using `WITH RESUME` for errors -535 and -255 makes the procedure flexible: it can be executed standalone (it will create and commit its own transaction) or executed by Spring (it will politely ignore its own transaction commands and let Spring handle the COMMIT/ROLLBACK).

```sql
CREATE PROCEDURE "informix".sp_charge_monthly_fee(
    p_acc_id INT
    ,p_fee DECIMAL(10,2)
)
-- Interesting, the OLTP usually does not use these (...)
DEFINE v_sql_code INT;
DEFINE v_isam_code INT;

-- 1] Specific handler for Transaction State Errors (-535,-255)
-- If Spring already opened a transaction, BEGIN WORK throws -535.
-- If Spring already closed it, COMMIT WORK throws -255.
ON EXCEPTION IN (-535, -255) SET v_sql_code, v_isam_code
    -- Do nothing, but WITH RESUME tells Informix to jump back to the exact line AFTER the one that failed and keep going
END EXCEPTION WITH RESUME;



END PROCEDURE;
```