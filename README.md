<img width="826" height="438" alt="image" src="https://github.com/user-attachments/assets/d81f025a-2ac0-45c3-ba6f-121838f871a3" />


TenantId
08b9c4db-89f1-4ffd-b3ad-c214578b2bcc
TimeGenerated [UTC]
2025-08-19T20:51:02Z
OperationName
ApplicationGatewayFirewall
InstanceId
appgw_6
ClientIp
65.200.40.2
RequestUri
/api/requests/create/save
RuleSetType
OWASP CRS
RuleSetVersion
3.2
RuleId
942400
Message
SQL Injection Attack
Action
Matched
DetailedMessage
Pattern match (?i:\band\b(?:\s+(?:'[^=]{1,10}'(?:\s*?[=<>])?|\d{1,10}(?:\s*?[=<>])?)| ?(?:[\'"][^=]{1,10}[\'"]|\d{1,10}) ?[=<>]+)) at ARGS.
DetailedData
{and 6 found within [ARGS:instructionsToProvider:Billing for DOS: 8/5/21, 8/8/21, 8/23/21 and 6/3/24]}
FileDetails
REQUEST-942-APPLICATION-ATTACK-SQLI.conf
LineDetails
1044
Hostname
portal.chartswap.com
TransactionId
dff869d12fea3dc6edcb445c5d8bf135
Type
AGWFirewallLogs
_ResourceId
/subscriptions/dde9f7b1-2bde-48da-952e-f1a5c663ac23/resourcegroups/cs-prod-net-rg/providers/microsoft.network/applicationgateways/cs-prod-agw
