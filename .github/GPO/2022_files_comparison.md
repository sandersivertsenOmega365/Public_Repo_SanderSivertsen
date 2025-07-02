# Windows Server 2022 CIS L2 Policy Files Comparison

## File Information
- **Original File:** WindowsServer2022-CIS-L2.PolicyRules (460 policies)
- **Copy File:** WindowsServer2022-CIS-L2 copy.PolicyRules (514 policies)

## Summary
- **Added in Copy:** 58 policies
- **Removed in Copy:** 4 policies
- **Changed in Copy:** 0 policies

## Policies Added in Copy File

### SECURITY:Privilege Rights:SeAssignPrimaryTokenPrivilege=*S-1-5-19,*S-1-5-20
- **Type:** SecurityTemplate
- **Line Item:** `SeAssignPrimaryTokenPrivilege=*S-1-5-19,*S-1-5-20`

### SECURITY:Privilege Rights:SeAuditPrivilege=*S-1-5-19,*S-1-5-20
- **Type:** SecurityTemplate
- **Line Item:** `SeAuditPrivilege=*S-1-5-19,*S-1-5-20`

### SECURITY:Privilege Rights:SeBackupPrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeBackupPrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeBatchLogonRight=*S-1-5-32-544,*S-1-5-32-551,*S-1-5-32-559
- **Type:** SecurityTemplate
- **Line Item:** `SeBatchLogonRight=*S-1-5-32-544,*S-1-5-32-551,*S-1-5-32-559`

### SECURITY:Privilege Rights:SeChangeNotifyPrivilege=*S-1-5-11,*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-32-551
- **Type:** SecurityTemplate
- **Line Item:** `SeChangeNotifyPrivilege=*S-1-5-11,*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-32-551`

### SECURITY:Privilege Rights:SeCreateGlobalPrivilege=*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6
- **Type:** SecurityTemplate
- **Line Item:** `SeCreateGlobalPrivilege=*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6`

### SECURITY:Privilege Rights:SeCreatePagefilePrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeCreatePagefilePrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeCreatePermanentPrivilege=
- **Type:** SecurityTemplate
- **Line Item:** `SeCreatePermanentPrivilege=`

### SECURITY:Privilege Rights:SeCreateSymbolicLinkPrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeCreateSymbolicLinkPrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeCreateTokenPrivilege=
- **Type:** SecurityTemplate
- **Line Item:** `SeCreateTokenPrivilege=`

### SECURITY:Privilege Rights:SeDebugPrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeDebugPrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeDelegateSessionUserImpersonatePrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeDelegateSessionUserImpersonatePrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeDenyBatchLogonRight=*S-1-5-32-546
- **Type:** SecurityTemplate
- **Line Item:** `SeDenyBatchLogonRight=*S-1-5-32-546`

### SECURITY:Privilege Rights:SeDenyInteractiveLogonRight=*S-1-5-32-546
- **Type:** SecurityTemplate
- **Line Item:** `SeDenyInteractiveLogonRight=*S-1-5-32-546`

### SECURITY:Privilege Rights:SeDenyNetworkLogonRight=*S-1-5-32-546
- **Type:** SecurityTemplate
- **Line Item:** `SeDenyNetworkLogonRight=*S-1-5-32-546`

### SECURITY:Privilege Rights:SeDenyRemoteInteractiveLogonRight=*S-1-5-32-546
- **Type:** SecurityTemplate
- **Line Item:** `SeDenyRemoteInteractiveLogonRight=*S-1-5-32-546`

### SECURITY:Privilege Rights:SeDenyServiceLogonRight=*S-1-5-32-546
- **Type:** SecurityTemplate
- **Line Item:** `SeDenyServiceLogonRight=*S-1-5-32-546`

### SECURITY:Privilege Rights:SeEnableDelegationPrivilege=
- **Type:** SecurityTemplate
- **Line Item:** `SeEnableDelegationPrivilege=`

### SECURITY:Privilege Rights:SeImpersonatePrivilege=*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6
- **Type:** SecurityTemplate
- **Line Item:** `SeImpersonatePrivilege=*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6`

### SECURITY:Privilege Rights:SeIncreaseBasePriorityPrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeIncreaseBasePriorityPrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeIncreaseQuotaPrivilege=*S-1-5-19,*S-1-5-20,*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeIncreaseQuotaPrivilege=*S-1-5-19,*S-1-5-20,*S-1-5-32-544`

### SECURITY:Privilege Rights:SeIncreaseWorkingSetPrivilege=*S-1-5-19,*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeIncreaseWorkingSetPrivilege=*S-1-5-19,*S-1-5-32-544`

### SECURITY:Privilege Rights:SeInteractiveLogonRight=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeInteractiveLogonRight=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeLoadDriverPrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeLoadDriverPrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeLockMemoryPrivilege=
- **Type:** SecurityTemplate
- **Line Item:** `SeLockMemoryPrivilege=`

### SECURITY:Privilege Rights:SeMachineAccountPrivilege=
- **Type:** SecurityTemplate
- **Line Item:** `SeMachineAccountPrivilege=`

### SECURITY:Privilege Rights:SeManageVolumePrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeManageVolumePrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeNetworkLogonRight=*S-1-5-11,*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeNetworkLogonRight=*S-1-5-11,*S-1-5-32-544`

### SECURITY:Privilege Rights:SeProfileSingleProcessPrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeProfileSingleProcessPrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeRelabelPrivilege=
- **Type:** SecurityTemplate
- **Line Item:** `SeRelabelPrivilege=`

### SECURITY:Privilege Rights:SeRemoteInteractiveLogonRight=*S-1-5-32-544,*S-1-5-32-555
- **Type:** SecurityTemplate
- **Line Item:** `SeRemoteInteractiveLogonRight=*S-1-5-32-544,*S-1-5-32-555`

### SECURITY:Privilege Rights:SeRemoteShutdownPrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeRemoteShutdownPrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeRestorePrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeRestorePrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeSecurityPrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeSecurityPrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeServiceLogonRight=*S-1-5-80-0
- **Type:** SecurityTemplate
- **Line Item:** `SeServiceLogonRight=*S-1-5-80-0`

### SECURITY:Privilege Rights:SeShutdownPrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeShutdownPrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeSyncAgentPrivilege=
- **Type:** SecurityTemplate
- **Line Item:** `SeSyncAgentPrivilege=`

### SECURITY:Privilege Rights:SeSystemEnvironmentPrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeSystemEnvironmentPrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeSystemProfilePrivilege=*S-1-5-32-544,*S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420
- **Type:** SecurityTemplate
- **Line Item:** `SeSystemProfilePrivilege=*S-1-5-32-544,*S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420`

### SECURITY:Privilege Rights:SeSystemtimePrivilege=*S-1-5-19,*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeSystemtimePrivilege=*S-1-5-19,*S-1-5-32-544`

### SECURITY:Privilege Rights:SeTakeOwnershipPrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeTakeOwnershipPrivilege=*S-1-5-32-544`

### SECURITY:Privilege Rights:SeTcbPrivilege=
- **Type:** SecurityTemplate
- **Line Item:** `SeTcbPrivilege=`

### SECURITY:Privilege Rights:SeTimeZonePrivilege=*S-1-5-19,*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeTimeZonePrivilege=*S-1-5-19,*S-1-5-32-544`

### SECURITY:Privilege Rights:SeTrustedCredManAccessPrivilege=
- **Type:** SecurityTemplate
- **Line Item:** `SeTrustedCredManAccessPrivilege=`

### SECURITY:Privilege Rights:SeUndockPrivilege=*S-1-5-32-544
- **Type:** SecurityTemplate
- **Line Item:** `SeUndockPrivilege=*S-1-5-32-544`

### SECURITY:Registry Values:MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableVirtualization=4,1
- **Type:** SecurityTemplate
- **Line Item:** `MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableVirtualization=4,1`

### SECURITY:Registry Values:MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\FilterAdministratorToken=4,1
- **Type:** SecurityTemplate
- **Line Item:** `MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\FilterAdministratorToken=4,1`

### SECURITY:Registry Values:MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeCaption=1,"Unauthorized users are prohibited"
- **Type:** SecurityTemplate
- **Line Item:** `MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeCaption=1,"Unauthorized users are prohibited"`

### SECURITY:Registry Values:MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeText=7,Unauthorized users are prohibited
- **Type:** SecurityTemplate
- **Line Item:** `MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeText=7,Unauthorized users are prohibited`

### SECURITY:Registry Values:MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\DisablePasswordChange=4,0
- **Type:** SecurityTemplate
- **Line Item:** `MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\DisablePasswordChange=4,0`

### SECURITY:Registry Values:MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\MaximumPasswordAge=4,30
- **Type:** SecurityTemplate
- **Line Item:** `MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\MaximumPasswordAge=4,30`

### SECURITY:Registry Values:MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\RequireSignOrSeal=4,1
- **Type:** SecurityTemplate
- **Line Item:** `MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\RequireSignOrSeal=4,1`

### SECURITY:Registry Values:MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\RequireStrongKey=4,1
- **Type:** SecurityTemplate
- **Line Item:** `MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\RequireStrongKey=4,1`

### SECURITY:Registry Values:MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\SealSecureChannel=4,1
- **Type:** SecurityTemplate
- **Line Item:** `MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\SealSecureChannel=4,1`

### SECURITY:Registry Values:MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\SignSecureChannel=4,1
- **Type:** SecurityTemplate
- **Line Item:** `MACHINE\System\CurrentControlSet\Services\Netlogon\Parameters\SignSecureChannel=4,1`

### SECURITY:System Access:EnableAdminAccount=1
- **Type:** SecurityTemplate
- **Line Item:** `EnableAdminAccount=1`

### SECURITY:System Access:EnableGuestAccount=0
- **Type:** SecurityTemplate
- **Line Item:** `EnableGuestAccount=0`

### SECURITY:System Access:NewAdministratorName="itomegahosting"
- **Type:** SecurityTemplate
- **Line Item:** `NewAdministratorName="itomegahosting"`

## Policies Removed in Copy File

### AUDIT:{0CCE924B-69AE-11D9-BED3-505054503030}:
- **Type:** AuditSubcategory
- **Setting:** `0`

### SECURITY:Registry Values:MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeCaption=1,"Properties of Omega365"
- **Type:** SecurityTemplate
- **Line Item:** `MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeCaption=1,"Properties of Omega365"`

### SECURITY:Registry Values:MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeText=7,This computer system is the property of Omega365. Access is restricted to authorized users only. Unauthorized use may result in disciplinary action and/or legal consequences. By continuing, you acknowledge monitoring may occur and consent to the organization's acceptable use policy.
- **Type:** SecurityTemplate
- **Line Item:** `MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeText=7,This computer system is the property of Omega365. Access is restricted to authorized users only. Unauthorized use may result in disciplinary action and/or legal consequences. By continuing, you acknowledge monitoring may occur and consent to the organization's acceptable use policy.`

### SECURITY:System Access:AllowAdministratorLockout=0
- **Type:** SecurityTemplate
- **Line Item:** `AllowAdministratorLockout=0`

