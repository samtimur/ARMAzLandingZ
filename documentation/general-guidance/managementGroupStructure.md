# Management Group and Subscription Organization

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

## Management Groups

Management group structures within an Azure Active Directory (Azure AD) tenant support organisational mapping and must be considered thoroughly when planning Azure adoption at scale. Subscriptions are a unit of management, billing, and scale within Azure. They play a critical role when designing for large-scale Azure adoption. This critical design area helps capture subscription requirements and design target subscriptions based on critical factors. These factors are environment type, ownership and governance model, organisational structure, and application portfolios.

### Management Group Design Decisions

* The Management Group structure will segregate platform services and workload resources.
* Management Groups will be created to structure subscriptions into logical groupings that align with DPIRD requirements around environment segregation and classification.

The Management Group structure will enable the Azure Policy and Azure RBAC structure to flow through to child Management Groups, subscriptions, and Azure resources. The proposed structure is modular and can iterate over time as the needs and requirements of the platform change.

Moving subscriptions between Management Groups in the future can be done without impacting the services that are running within the subscription. Subscriptions will lose all Azure Policies and RBAC permissions and will inherit the new policies and RBAC permissions from the Management Group.

### Overview

The management group and subscription structure that has been proposed is modular and aligns with the Enterprise Scale Landing Zone Architecture in the Microsoft Cloud Adoption Framework. It is anticipated that the Landing Zone management group structure would iterate over time and can be expanded to include further classification levels and environments as required without affecting the existing subscriptions or workloads within these subscriptions.

DIAGRAM

### Configuration

**Tenant Root Group:**
The default root management group will not be used directly, allowing for greater flexibility in the future to incorporate any changes to the structure and further expansion of Management Groups.

**DPIRD Root:**
This is the top-level management group implemented within the DPIRD Azure tenant and will serve as the container for all custom role definitions, custom policy definitions, and DPIRD global policy assignments, but will have minimal direct role assignments. For policy assignments at this scope, the target state is to ensure security and autonomy for the platform as additional sub scopes are created, such as child management groups and subscriptions.

**Landing Zones:**
All workloads will be created in subscriptions within child management groups of the Landing Zones management groups. This allows for a generic yet more granular approach to policy assignments to separate active subscriptions from Sandbox and Decommissioned subscriptions.

**Corporate:**

**Online:**

**Decommissioned:**
All cancelled subscriptions will be moved under this management group by Azure Policy and will be deleted after 90 days.

**Platform:**
The Platform management group will be the parent for the Connectivity, Management, and Identity child management groups. RBAC permissions and Azure policies will be assigned at this level for roles that will be responsible for managing and maintaining the platform and key Azure Policies that will drive the build of the platform.

**Connectivity:**
A dedicated subscription will be utilised for the centrally managed networking infrastructure which will control end-to-end connectivity for all Landing Zones within the DPIRD Azure platform. Azure resources that will be deployed into this subscription include virtual network hubs, ExpressRoute circuits and associated gateways, firewalls, and Azure Private DNS Zones.

**Identity:**
The Identity management group will have a dedicated Identity subscription that will be used to host VMs running Windows Server Active Directory.

**Management:**
A dedicated Management subscription will reside in this management group and be utilized for centrally managed platform infrastructure to ensure a holistic at-scale management capability across all Landing Zones within the DPIRD Azure platform.

## Subscriptions

Subscriptions are a unit of management, billing, and scale within Azure. They play a critical role when you're designing for large-scale Azure adoption. This section helps you capture subscription requirements and design target subscriptions based on critical factors. These factors are environment type, ownership and governance model, organizational structure, and application portfolios.

### Subscription Design Decisions

* Azure subscriptions aligning to Landing Zones will be created beneath the required Management Groups to ensure that all Azure Policies, RBAC, and inheritance of subscription scaffolding is addressed as part of the creation process.
* There will be separate subscriptions created to align to Production and Non-Production environments for applications and solutions.
* These Landing Zone subscriptions will be created as required to align with new projects or initiatives. 
* Dedicated Platform subscriptions (Connectivity, Management, Identity) will be created to separate platform services from workloads. 
* All sandbox subscriptions should be enabled for the Enterprise Dev/Test offer to reduce the cost for these non-critical subscriptions. DPIRD who access these subscriptions via the portal Must-Have a valid MSDN license to ensure compliance to Microsoft licensing, more details can be found here.
* As subscriptions are decommissioned, they will be placed in the Decommissioned Management Group to ensure that resources cannot be installed within these subscriptions.

The creation of new subscriptions will align with the future build-out of the Azure platform. The segregation of these subscriptions allows alignment to environments, classifications, and platform services. Enterprise Dev/Test subscriptions occur at a lower cost for some Azure resources ensuring development and evaluation activities can be done in these subscriptions as a cost-saving measure.

An Azure subscription should be a democratised unit of management aligned to DPIRD requirements and priorities, the creation process and management of these subscriptions will need to be addressed as the environment and landscape expand. DPIRD should avoid a rigid subscription model and instead opt for a set of flexible criteria to group subscriptions across the organisation. This flexibility ensures that as the structure and workload composition changes, new subscription groups can be instead of using a fixed set of existing subscriptions.

### Overview

DIAGRAM

### Configuration

| Platform Subscriptions    | Azure Regions                                    |
|---------------------------|--------------------------------------------------|
| Management                | Australia East                                   |
| Connectivity              | Australia East                                   |
| Identity                  | Australia East                                   |

#### Landing Zone Subscriptions

| Landing Zone Subscriptions    | Azure Regions                                    |
|-------------------------------|--------------------------------------------------|
|                               | Australia East                                   |
|                               | Australia East                                   |
|                               | Australia East                                   |