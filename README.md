# RetailDW Project

Retail Data Warehouse using SQL Server, SSIS, ETL/ELT Medallion Architecture and Power BI.

---

## Team Members

| Name | Role |
|------|------|
| Justin Phoo Hoe Yin | ETL Developer / Inventory & Product Module |
| Team Member 2 | Customer Module |
| Team Member 3 | Sales Module |

---

# Project Architecture

CSV Files
      │
      ▼
Staging
      │
      ▼
Bronze Layer
      │
      ▼
Silver Layer
      │
      ▼
Gold Layer
      │
      ▼
Power BI Dashboard

---

## Technologies

- SQL Server 2022
- SQL Server Integration Services (SSIS)
- SQL Server Management Studio (SSMS)
- Visual Studio 2022
- Power BI Desktop
- GitHub

---

## Folder Structure

```
RetailDW_Project
│
├── SQL
│
├── RetailDW_SSIS
│
├── Documentation
│
└── README.md
```

---

## SQL Folder

Contains:

- Database creation
- Schemas
- Staging scripts
- Bronze scripts
- Silver scripts
- Gold scripts
- Stored Procedures

---

## SSIS Folder

Contains packages for:

- Load_Staging.dtsx
- Load_Bronze.dtsx
- Load_Silver.dtsx
- Load_Gold.dtsx

---

## Audit & Logging Architecture

Every stage of the pipeline writes to the `audit` schema so each run is traceable
end-to-end. There is no single shared log table — each module logs to its own
table, and the Gold layer uses a shared execution log since it has no rejection
concept.

| Table | Used by | Purpose |
|---|---|---|
| `audit.Sales_Pipeline_Log` | Sales Bronze + Silver | RowsIn / RowsOut / RowsRejected / rejection breakdown per run |
| `audit.Customer_Pipeline_Log` | Customer Bronze + Silver | Same, for the Customer module |
| `audit.Product_Pipeline_Log` | Product Bronze + Silver | Same, for the Product module |
| `audit.Sales_Rejected` | Sales Silver | Row-level detail of rejected sales records with reason |
| `audit.Customer_Rejected` | Customer Silver | Row-level detail of rejected customer records with reason |
| `audit.Product_Rejected` | Product Silver | Row-level detail of rejected product records with reason |
| `audit.Execution_Log` | All Gold procedures | LayerName / ModuleName / ProcedureName / RowsAffected / ExecutedAt |

Every `usp_Load_*` procedure inserts one row into its corresponding log table
automatically at the end of a successful run — nothing needs to be logged
manually.

### Stored Procedures (`etl` schema)

**Bronze**
- `usp_Load_Customer_Bronze`
- `usp_Load_Sales_Bronze`
- `usp_Load_Product_Bronze`

**Silver**
- `usp_Load_Customer_Silver`
- `usp_Load_Sales_Silver`
- `usp_Load_Product_Silver`

**Gold**
- `usp_Load_DimCustomer`
- `usp_Load_DimProduct`
- `usp_Load_DimDate`
- `usp_Load_FactSales`

### Verification performed

- **Idempotency:** every procedure produces identical row counts across
  repeated executions (Bronze → Silver → Gold).
- **Referential integrity:** `gold.FactSales` has zero orphaned
  `ProductKey` / `CustomerKey` / `DateKey` — every fact row resolves to a
  valid dimension row.
- **Data quality checks:** no duplicate natural keys (`OrderID`,
  `CustomerID`, `ProductCategory + ProductName`), no out-of-range values
  (negative shipping cost, invalid age, non-positive quantity, etc.) in any
  Silver or Gold table.

---

## Setup Instructions

### 1. Restore SQL Server database

Run the SQL scripts in the following order:

1. Database
2. Schemas
3. Staging
4. Bronze
5. Silver
6. Gold
7. Stored Procedures

---

### 2. Open SSIS Project

Open

RetailDW_SSIS.sln

using Visual Studio 2022.

---

### 3. Update Connection Manager

Before running SSIS:

- Open each package
- Edit the Connection Manager
- Change the SQL Server name if required

---

### 4. Execute Packages

Run in this order:

1. Load_Staging
2. Load_Bronze
3. Load_Silver
4. Load_Gold

Each procedure writes its own audit trail automatically — see
[Audit & Logging Architecture](#audit--logging-architecture) above to query
run history afterward.

---

## Notes

- Always pull before pushing.
- Do not modify another member's module without discussion.
- Commit small changes with meaningful commit messages.
- Always confirm you are connected to the `RetailDW` database (not a
  differently-named database) before running or modifying any script —
  check `SELECT DB_NAME();` if unsure.

Example commit messages:

```
Added Gold FactSales procedure

Fixed Customer Silver transformation

Updated SSIS Load_Gold package

Add audit logging to all ETL procedures across Bronze/Silver/Gold layers
```

---

## Version

Version 1.1
