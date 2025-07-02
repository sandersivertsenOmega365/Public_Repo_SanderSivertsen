# Windows Server 2022 CIS L2 Policy Files Comparison

## Executive Summary

- **Original File:** 460 policies
- **Copy File:** 514 policies
- **Changes:** +58 added, –4 removed, 0 modified

## Added Policies (58)

- New **Privilege Rights** assignments (e.g., SeAssignPrimaryTokenPrivilege, SeAuditPrivilege, SeDebugPrivilege, SeRemoteInteractiveLogonRight, etc.)
- **User Rights** tweaks covering logon, service, backup, restore, shutdown and system privileges
- **Registry Values** for UAC filtering (EnableVirtualization, FilterAdministratorToken), legal notices, and Netlogon security parameters

## Removed Policies (4)

- **Audit Subcategory** `{0CCE924B-69AE-11D9-BED3-505054503030}` set to 0
- **Registry Legal Notice** (Omega365-specific caption and text)
- **System Access** setting `AllowAdministratorLockout=0`

*No policies were modified between the two files.*