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

