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

---

## Notes

- Always pull before pushing.
- Do not modify another member's module without discussion.
- Commit small changes with meaningful commit messages.

Example:

```
Added Gold FactSales procedure

Fixed Customer Silver transformation

Updated SSIS Load_Gold package
```

---

## Version

Version 1.0
