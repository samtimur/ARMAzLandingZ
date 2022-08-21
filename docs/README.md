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

## Objective

The Azure Foundations architecture provides prescriptive guidance coupled with Azure best practices, and it follows design principles across the critical design areas for organizations to define their Azure architecture. It will continue to evolve alongside the Azure platform and is ultimately defined by the various design decisions that organizations must make to define their Azure journey.

The Azure Foundations architecture is modular by design and allow organizations to start with foundational landing zones that support their application portfolios, and the architecture enables organizations to start as small as needed and scale alongside their business requirements regardless of scale point.

---

_The Azure Foundations architecture represents the strategic design path and target technical state for your Azure environment._

---

Not all customers adopt Azure in the same way, so the Azure Foundations architecture may vary between customers. Ultimately, the technical considerations and design recommendations of the Azure Foundations architecture may lead to different trade-offs based on the customer's scenario. Some variation is expected, but if core recommendations are followed, the resulting target architecture will put the customer on a path to sustainable scale.

The Azure Foundations reference implementations in this repository are intended to support Azure adoption and provides prescriptive guidance based on authoratative design for the Azure platform as a whole.

| Key customer landing zone requirement | Azure Foundations reference implementations |
|----------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Timelines to reach security and compliance requirements for a workload | Enabling all recommendations during setup, will ensure resources are compliant from a monitoring and security perspective |
| Provides a baseline architecture using multi-subscription design | Yes, for the entire Azure tenant regardless of customer’s scale-point |
| Best-practices from cloud provider | Yes, proven and validated with customers |
| Be aligned with cloud provider’s platform roadmap | Yes |
| UI Experience and simplified setup | Yes, Azure portal |
| All critical services are present and properly configured according to recommend best practices for identity & access management, governance, security, network and logging | Yes, using a multi-subscription design, aligned with Azure platform roadmap |
| Automation capabilities (IaC/DevOps) | Yes: ARM, Policy, GitHub/Azure DevOps CICD pipeline option included |
| Provides long-term self-sufficiency | Yes, the Azure Foundations architecture prepare the customer for long-term self-sufficiency |
| Enables migration velocity across the organization | Yes, the Azure Foundations architecture includes designs for segmentation and separation of duty to empower teams to act within appropriate landing zones |
| Achieves operational excellence | Yes. Enables autonomy for platform and application teams with a policy driven governance and management |

## Deploying the Azure Foundations Architecture

The Azure Foundations architecture is modular by design and allows customers to start with foundational Landing Zones that support their application portfolios, regardless of whether the applications are being migrated or are newly developed and deployed to Azure. The architecture can scale alongside the customer's business requirements regardless of scale point.

## Conditions for success

To fully leverage this reference architecture, there must be a collaborative engagement with key customer stakeholders across critical technical domains, such as identity, security, and networking. Ultimately, the success of cloud adoption hinges on cross-discipline cooperation within the organization, since key pre-requisite design decisions are cross cutting, and to be authoritative must involve domain Subject Matter Expertise (SME) and stakeholders within the customer. It is crucial that the organization has defined their [Azure Foundations Architecture](./00-azureFoundations-architecture.md) following the design principles and critical design areas.

It is also assumed that readers have a broad understanding of key Azure constructs and services in order to fully contextualize the prescriptive recommendations contained within this architecture.

## What will be deployed?

The following resources have been provisioned as part of the deployment.

* A scalable Management Group hierarchy aligned to core platform capabilities, allowing Silver Chain to operationalize at scale using centrally managed Azure RBAC and Azure Policy where platform and workloads have clear separation.
* Azure Policies that will enable autonomy for the platform and the landing zones.
* An Azure subscription dedicated for the **platform**, which enables core platform capabilities across Identity, Networking and Management services, such as:
  * A Log Analytics workspace and an Automation account
  * Azure Security Center monitoring
  * Azure Security Center (Free tier)
  * Diagnostics settings for Activity Logs, VMs, and PaaS resources sent to Log Analytics
  * A hub virtual network and associated subnets
  * Network Security Groups assigned to all subnets
  * User Define Routes to redirect traffic to the Azure Firewall
  * Azure Firewall
  * ExpressRoute Gateway
* Application Landing Zone Management Group for **production** and **non-production** applications that require connectivity to on-premises, to other landing zones or to the internet via shared services provided in the hub virtual network.
* Azure Policies for **production** and **non-production** landing zones, which include:
  * Enforce VM monitoring (Windows & Linux)
  * Enforce secure access (HTTPS) to storage accounts
  * Prevent IP forwarding
  * Prevent inbound SSH from internet
  * Prevent inbound RDP from internet
  * Prevent Public IP addresses
  * Prevent Public endpoints for all Azure PaaS services
  * Ensure subnets are associated with NSG
  * Appending environment tags to all resources
  