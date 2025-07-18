# aduserexporter
AD User Exporter



# 🧑‍💻 AD User Exporter - by X1 (v0.2.6)

A modern PowerShell tool for exporting **Active Directory active users**, with intelligent filtering to produce clean, audit-ready user lists.

---

## ✨ Features

✅ Exports **all active (enabled)** AD user accounts to `raw.csv`  
✅ Creates a **clean, filtered list** in `striped.csv` by:
- Removing service and admin accounts (`svc`, `admin`, `service`, etc.)
- Skipping users with both `Company` and `Department` empty
- Keeping only users with relevant organisation info  
✅ Automatically saves exports to the same folder as the script  
✅ Fully colourised terminal output for better readability  
✅ Written in PowerShell using native AD commands

---

## 📂 Output Files

| File Name     | Description                                                                 |
|---------------|-----------------------------------------------------------------------------|
| `raw.csv`     | All active AD users with display name, username, email, department, company |
| `striped.csv` | Cleaned list — excludes service/admin/mailbox users, requires org info      |

---

## 🧠 How It Works

The script fetches all users where `Enabled -eq $true`, then:

1. Exports all results to `raw.csv`
2. Filters out accounts based on:
   - Keywords like `admin`, `svc`, `service`, `new era`, `ingerop`
   - **Empty `Company` and `Department` fields**
3. Exports the cleaned list to `striped.csv`

All processing is done in memory and saved in the current script directory.

---

## 🚀 Getting Started

### 🔧 Requirements

- PowerShell 5.1 or higher
- RSAT tools with **Active Directory module** installed
- Domain-joined machine or AD-connected workstation

### ▶️ Usage

```powershell
.\Export-ADUsers.ps1


