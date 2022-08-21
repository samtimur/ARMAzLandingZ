# Naming Conventions

* [Azure Foundations Architecture Overview](./00-Azure-Foundations-Architecture-Overview.md)
  * [Design Guidelines & Principles](./01-Design-Guidelines&Principles)
  * [Design](./02-Design.md)
    * [A - Enterprise Enrollment and Azure AD Tenants](./A-Enterprise-Enrollment-and-Azure-AD-Tenants.md)
    * [B - Identity and Access Management](./B-Identity-and-Access-Management.md)
    * [C - Management Group and Subscription Organization](./C-Management-Group-and-Subscription-Organization.md)
    * [D - Network Topology and Connectivity](./D-Network-Topology-and-Connectivity.md)
    * [E - Management and Monitoring](./E-Management-and-Monitoring.md)
    * [F - Business Continuity and Disaster Recovery](./F-Business-Continuity-and-Disaster-Recovery.md)
    * [G - Security, Governance and Compliance](./G-Security-Governance-and-Compliance.md)
    * [H - Platform Automation and DevOps](./H-Platform-Automation-and-DevOps.md)

Route names
	
	"FROM-subnet-TO-default-0.0.0.0-0",
	"FROM-subnet-TO-ADDRESS-SPACE",
	

NSG Rules
Inbound 
	"INBOUND-FROM-<SOURCE-LOCATION>-TO-<DESTINATION-LOCATION-PORT-443-PROT-TCP-ALLOW/DENY
	4000 deny rule "INBOUND-FROM-any-TO-any-PORT-any-PROT-any-DENY
outbound
	"OUTBOUND-FROM-<SOURCE-LOCATION>-TO-<DESTINATION-LOCATION-PORT-443-PROT-TCP-ALLOW/DENY
	4000 deny rule "OUTBOUND-FROM-any-TO-any-PORT-any-PROT-any-DENY

Firewall Policy Names

