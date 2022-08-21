# Navigation Menu

* [Azure Foundations Architecture](./00-azureFoundations-architecture.md)
  * [Design Guidelines & Principles](./01-azureFoundations-design-guidelines-principles.md)
    * [A - Enterprise Enrollment and Azure AD Tenants](./A-Enterprise-Enrollment-and-Azure-AD-Tenants.md)
    * [B - Identity and Access Management](./B-Identity-and-Access-Management.md)
    * [C - Management Group and Subscription Organization](./C-Management-Group-and-Subscription-Organization.md)
    * [D - Network Topology and Connectivity](./D-Network-Topology-and-Connectivity.md)
    * [E - Management and Monitoring](./E-Management-and-Monitoring.md)
    * [F - Business Continuity and Disaster Recovery](./F-Business-Continuity-and-Disaster-Recovery.md)
    * [G - Security, Governance and Compliance](./G-Security-Governance-and-Compliance.md)
    * [H - Platform Automation and DevOps](./H-Platform-Automation-and-DevOps.md)
  * [Design](./02-azureFoundations-design.md)

## Scope

Update this to be Communities specific.

## Communities Azure Foundations Architecture

### Enterprise Enrollment and Azure AD Tenants

TBC

### Identity and Access Management

TBC

### Management Group and Subscription Organization

Communities is designing their management group hierarchy and subscription organization to optimize for scale, enabling autonomy for the platform and application teams to evolve alongside business requirements. The subscription naming convention will be "Company Identifier" followed by an "Environment Identifier", for example "DCS-Production-LZ", "DCS-Dev-LZ", "DCS-Platform-LZ".

Communities has decided to use Azure subscriptions across Azure regions, which will greatly simplify networking and connectivity. Workloads that do require multiple regions, will reside within the same Azure subscription including for business continuity and disaster recovery purposes.

The table below outlines the subscriptions that will be enabled across both Australia East and Australia SouthEast, these can change over time and CIDR ranges will be assigned to allow this to happen

| Azure Subscriptions    |      Azure Regions                               |
|------------------------|--------------------------------------------------|
| DoC-Platform-LZ        | Australia East (SYD)                             |
| DoC-Production-LZ      | Australia East (SYD) & Australia SouthEast (MEL) |
| DoC-Dev-LZ             | Australia East (SYD)                             |
| DoC-Test-LZ            | Australia East (SYD)                             |

Communities has decided to use Azure Resource Tags for billing and show back/charge back purposes, instead of blending a cost management structure within the Management Group and Subscription hierarchy. This will provide horizontal capabilities to query cost across multiple subscriptions. Tags required for billing (Owner, Environment, CreatedDate) will be enforced by policy at the various scopes

#### Management Groups

**Tenant Root Group**
The default root management group will not be used directly, allowing for greater flexibility in the future to incorporate any changes to the structure and further Management Groups.

**DoC**
This is the top-level management group implemented within Communities's Azure tenant and will serve as the container for all custom role definitions, custom policy definitions, and Communities global policy assignments, but will have minimal direct role assignments. For policy assignments at this scope, the target state is to ensure security and autonomy for the platform as additional sub scopes are created, such as child management groups and subscriptions.

**AppLandingZones**
All workloads will be created in subscriptions within child management groups of the Application Landing Zones management groups. This allows for a generic yet more granular approach to policy assignments to more easily separate active landing zones from sandbox subscriptions and decommissioned subscriptions.

**Production, Dev, Test**
Communities has identified 3 common archetypes they will migrate/deploy to Azure and have developed the requisite policies to ensure appropriate guard-rails are in place for each landing zone that is created as these management groups.

Azure policy will require tags for each subscription that will be created, to identify ownership, billing and show/charge back.

* Production -
* Dev -
* Test -

**Sandbox**
Application teams and individual users within Communities wanting to test and explore Azure services will have subscriptions created within the Sandbox management group. In this group, policies are in place to ensure there is no control plane or data plane path to production environments. This includes network connectivity into the Platform LZ and in turn on-premises environment.

**Decommissioned**
All cancelled subscriptions will be moved under this management group by Azure Policy and will be deleted after 60 days.

**Platform**
The Platform Management Group will house a dedicated subscription that will be utilized for all centrally managed Platform infrastructure, including Network Connectivity, Management Services and Identity which will be leveraged by all Application Landing Zones within Communities's Azure platform. Azure resources that will be deployed into this subscription including Azure Networking (Virtual Network Hubs, Network Security Groups, User Defined Routes, Gateways, DNS, ExpressRoute, Azure Firewall and Policies), Azure Management Services (Log Analytics Workspace, Azure Automation, Azure Key Vault, Azure Security Center, Azure Monitor, Azure Cost Management, Recovery Services Vaults and Diagnostics Storage Accounts) and Identity Services (Active Directory Domain Controllers, Azure AD Connect and all other associated Identity services)

The Platform LZ Azure subscription will have the tag "Owner" with the value "Platform".

***Identity***
The "Identity" Resource Groups will be used to host VMs running Windows Server Active Directory. There will be at least two domain controllers deployed per Azure region for redundancy purposes, and to ensure regions are independent in the case of a regional outage. AD replication will ensure all domain controllers are kept in sync.

***Management***
TBC

***Networking***
TBC

All Management Group Azure Policies have been defined in the following spreadsheet.

## Network Topology and Connectivity

Contoso has a presence across Europe and North America. Contoso's headquarters are located in London, UK. Contoso also has regional HQ offices in Amsterdam and Chicago. Contoso has a large number of branch offices (around 500) across the US and Europe. Each branch office contains a CPE that is connected to the local regional HQ via S2S VPN.

Contoso has decided to adopt North Star recommendations for building their network architecture in Azure. Key decisions they have adopted include:

1. The deployment of a Microsoft-managed network in Azure using Azure Virtual WAN to interconnect all Azure and on-premises locations around the world.

2. Use of ExpressRoute Global Reach to interconnect corporate HQs with regional hubs.

3. Move away from their traditional DMZ-model and adopt a Zero-Trust network model.

4. Allow full subscription democratization by giving Landing Zone Owners' rights to create subnets within their landing zones to suit their application needs while ensuring the platform maintains compliance and security as defined by the SecOps team.

Contoso's network design based on NorthStar design principles is depicted in the picture shown below:

![Network topology](./media/image5.png)

With this network design, Contoso enables the following scenarios:

* Regional HQ offices connectivity to Azure via ExpressRoute.
* Branch offices connectivity to Azure via VPN (S2S IPSec tunnels).
* Landing Zone VNets are connected to the regional Azure Virtual WAN VHub.
* Regional HQs to Regional HQs connectivity via ExpressRoute with Global Reach.
* Regional HQs to branch offices connectivity via Azure Virtual WAN.
* Regional HQs and branch offices connectivity to Azure VNets via Azure Virtual WAN.
* Internet-outbound connectivity from Azure VNets is secured using Azure Firewall within the Virtual WAN VHub.

Contoso decided to deploy a Azure Virtual WAN (Microsoft managed) based network topology in order to enable global inter-connectivity between on-premises and Azure as well as support a large number of branches that need to be connected to Azure. The following diagram depicts the required Azure resources which must be deployed inside the "Connectivity" subscription to support Contoso's global Azure network:

![Connectivity Subscriptio](./media/image7.png)

In order to simplify the routing configuration across the entire Azure networking platform, Contoso has assigned the following IP address spaces for Azure Virtual WAN VHubs and Virtual Networks:

* North Europe: 10.1.0.0/16
* West Europe: 10.2.0.0/16
* North Central US: 10.3.0.0/16

Since Contoso must support those three Azure regions (North Europe, West Europe and North Central US), Contoso has documented the required resources and parameters so that the platform can be deployed via Azure Policy in alignment with North Star guidance. More specifically, all these resources will be deployed within the "Connectivity" subscription and enforced by Deploy-If-Not-Exist Policies.

## Management and Monitoring

Contoso will employ a monitoring strategy where the central team will be responsible for the all-up platform logging, security and networking and will use Azure native services such as Log Analytics, Monitor, Security Center, Sentinel, and Network Watcher. All core management infrastructure will exist inside the dedicated Management subscription and will be deployed and governed by Azure Policy; the requisite configuration for workloads and subscriptions will be driven through Azure policy as new subscriptions and resources are being created. The following diagram depicts the required Azure resources that must be deployed within the "Management" subscription to support Contoso's platform management and monitoring:

![Monitoring Subsciption](.//media/image9.png)

Since Contoso has selected West Europe as their primary Azure region, they will use a single Log Analytics workspace within West Europe for centralized platform management which will also act as the hub for all security and networking data across their Azure platform. With this design and implementation, they will achieve:

* A single, central, and horizontal view of the platform across security, auditing, and networking, all enforced by Azure Policy and "deployIfNotExists".
  * Consume security data centrally from all subscriptions.
  * Consume networking data centrally from all regions and subscriptions where networks are deployed.
* Granular data retention per data table in Log Analytics.
* Resource centric and granular RBAC for application teams to access their monitoring data.
* At scale emergency VM patching as well as granular VM patching for application teams per RBAC.
* Centralized alerting from a platform perspective.
* Centralized, interactive Azure dashboards through the lenses of networking, security, and overall platform health.

Contoso has documented the resources and parameters that it requires so that the platform can be managed and monitored via Policy as per NorthStar guidance. All these resources will be deployed in the "Management" subscription.

## Business Continuity and Disaster Recovery

Core Contoso North Star platform components across all regions consider an active-active design i.e. Identity, Management and Networking are considered as highly available in all regions and can function independent of each other.

Contoso has defined the following BCDR guidelines when applications are moved to Azure to allow application owners to ensure their applications (either cloud native apps or traditional IaaS workloads) are architected and deployed to meet HA and DR requirements:

### High availability

* Application architectures should be built using a combination of Availability Zones across the North Europe and West Europe paired Azure regions. More specifically, applications and their data should be synchronously replicated across Availability Zones within an Azure region (North Europe) for high-availability purposes, and asynchronously replicated across Azure regions (West Europe) for disaster recovery protection.
* Azure services that provide native replication across Availability Zones should be used as a preference, such as Zone-Redundant Storage and Azure SQL DB.
* Stateless virtual machine workloads should be deployed across multiple instances in Availability Zones behind a Load Balancer standard or Application Gateway (v2).
* Stateful virtual machine workloads should leverage application-level replication across Availability Zones, such as SQL AlwaysOn.
* Stateful virtual machine workloads that do not support application level replication should use Azure Site Recovery Zonal-Replication (preview).

### Disaster Recovery

* Application architectures should use native application replication technologies such as SQL AlwaysOn, for stateful virtual machines in order to replicate data from one Azure region (North Europe) region to the paired Azure region (West Europe).
* Applications should use Azure Site Recovery to replicate stateful virtual machines that do not support application-level replication.
* Stateless virtual machine workloads can be quickly re-created (or pre-provisioned) in the paired Azure region (West Europe). Alternatively, Azure Site Recovery could also be used.
* For externally facing applications that must always be available, an active/active or active/passive deployment pattern across the North Europe and West Europe regions should be used, utilizing either Azure Front Door or Azure Traffic Manager to ensure applications are accessible at all times even if one of the Azure regions is not available.
* Applications should be transformed and modernized where possible to use Azure PaaS services that provide native replication techniques across regions, such as Cosmos DB, Azure SQL DB, and Azure Key Vault.

### Backup

Azure Backup is the native backup solution built into the platform and is recommended to use for all supported services. In cases where it is not supported, other options need to be considered by the application team in charge of the respective landing zone to ensure data consistency and business continuity.  

The platform team will provide a HA/DR baseline for VM backup policies across Azure, which will be deployed to each landing zone through policy. This will ensure that each resource group within a landing zone containing virtual machines has a Backup Vault and that the backup setting is enabled. Additionally, the platform team will collect backup diagnostic data in the central Log Analytics instance, providing a horizontal view over the entire backup estate.

Contoso also recognizes the need to add backup capabilities to other resource types other than Virtual Machines. However, given the highly specific nature of these backups and the different approaches an application team can take to backup, Contoso does not enforce these settings centrally.

## Security, Governance and Compliance

For Contoso to understand what controls must be implemented, and where these controls must be layered in their Azure architecture, they have developed and established a control framework to map their requirements to Azure platform capabilities. The framework principals are data protection, network protection, key management, vulnerability, and least privilege to ensure any allowed Azure service can conform to Contoso's enterprise security requirements, which are implemented using Azure Policy, Azure AD PIM, Azure RBAC, Azure Security Center, Azure Sentinel, and Azure Monitor.

Through policy-driven management, Contoso's policy implementation will ensure new subscriptions and resources will immediately be brought to their target compliant state. The primary policy effects used by Contoso to achieve this are "deployIfNotExists", "deny", "append", and "modify".

* For "deployIfNotExist" policies, Contoso ensures IaaS and PaaS resources, as well as new subscriptions, are compliant during creation regardless of *how* it is being created.
* For "deny" policies, Contoso ensures the appropriate guardrails are in place to avoid misconfigurations, such as accidentally deploying a workload that is not allowed and/or deploying to a region that is not explicitly allowed.
* For "append" policies, Contoso can add the necessary tags to resources without requiring user interaction or input upfront, helping to ensure appropriate cost centers etc. are applied.
* For "modify" policies, Contoso can easily make horizontal changes to the tag metadata on resources in case of organizational changes, expansions, or other factors that may impact the organization of resources.
Contoso's existing Azure subscriptions will initially start with "audit" and "auditIfNotExists" policies to understand the current resource distribution from a compliance perspective as well as what changes are necessary to bring the existing subscriptions with their resources into the target landing zones.  
From a platform architecture perspective, the principals of Contoso policy implementation will ensure that:

* Platform is autonomous  
When a new subscription is created, Azure Policy will automate and ensure requisite plumbing is in place, such as security, networking, logging and workload specific policies mapped to Contoso's controls.
* Security is non-negotiable  
Any workload that is deployed into Contoso's Azure environment is monitored from a security perspective, and enforcement is in place to ensure data protection, network protection, encryption at-rest, encryption in-transit, and key management. This will reduce any vulnerability scenarios regardless of whether resources are subject to testing in a sandbox subscription, connected to the corporate network or the internet, or any other landing zone.
Contoso will use Compliance view in Azure Policy together with Azure Sentinel workbooks to review and monitor overall compliance and security posture for the tenant.

* Application teams are autonomous  
Contoso's Azure platform does not dictate how application teams should use Azure, leaving them free to use any client to interact with, deploy, and manage their applications in their subscriptions. However, Azure Policy will guarantee that their applications are deployed in a compliant way, by enforcing security, logging, backup, connectivity, and appropriate access.

All of Contoso's policyDefinitions and policyAssignments are treated as source code, and will be developed, reviewed, and deployed from their Git repository.

From an identity and access perspective, Contoso will develop their own custom RBAC roles to ensure the appropriate permissions (actions/notActions) for control plane and data plane access are available for the right persona at the right scope in the Azure hierarchy. This will of course be subject to just-in-time access with multi-factor authentication to all high-privileged roles. Contoso will use Azure AD reporting capabilities to generate access control audit reports.

## Platform Automation and DevOps

### Communities - Roles & Responsibilities

Communities has acknowledged that their existing on-premises operating model requires change to ensure they maximise the benefits of the cloud. Communities has decided to create a Platform Operations team who will oversee execution of the Azure Foundations architecture and will be accountable for the Communities Azure Platform. This Platform team will have representations from the following IT functions:

### Communities Platform DevOps

Communities will use the Git repo for Infrastructure-as-code (IaC) and instantiate the Management Group and Subscription hierarchy using the tenant level Azure Resource Manager template deployments. This repository is used for bootstrapping and managing their entire platform and hence will require access permissions for service principle at a tenant root scope. To simplify RBAC and management of client secrets for service principles, Communities will use a single service principle scoped at the tenant root scope which will have access to all resources inside a tenant. This account is the highest privilege account and no user will have direct access to the secrets of this service account.

**Deployment**
Communities infrastructure as code Git repo will have many configuration artifacts tracked and version controlled. Platform developers will be modifying a very small subset of these artifacts on an on-going basis via Pull Requests. Since Git represents the source of truth and change history, Communities will leverage Git to determine differential changes in each pull request and trigger subsequent Azure deployment actions for only those artifacts which have been changed instead of triggering a full deployment of all artifacts.
