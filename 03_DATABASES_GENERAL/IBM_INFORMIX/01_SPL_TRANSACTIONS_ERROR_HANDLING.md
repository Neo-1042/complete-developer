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