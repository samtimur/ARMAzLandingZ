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

## Azure Foundations Architecture Overview

The principle challenges facing customers adopting Azure are;

 1) how to allow applications (legacy or modern) to seamlessly move at their own pace.
 2) how to provide secure and streamlined operations, management, and governance across the entire platform and all encompassed applications. To address these challenges, customers require a forward looking and Azure-native design approach, which in the context of this playbook is represented by the Azure Foundations architecture.

### What is the Azure Foundations Architecture

The Azure Foundations Architecture represents the strategic design path and target technical state for the customer's Azure environment. It will continue to evolve in lockstep with the Azure platform and is ultimately defined by the various design decisions the customer organization must make to define their Azure journey.

It is important to highlight that not all customers adopt Azure in the same way, and as a result the architecture may vary between customers. Ultimately, the technical considerations and design recommendations presented within this playbook may yield different trade-offs based on the customer scenario. Some variation is therefore expected, but provided core recommendations are followed, the resultant target architecture will position the customer on a path to sustainable scale.

### Landing Zones Definition

Within the context of the Azure Foundations Architecture, a "Landing Zone" is a logical construct capturing everything that must be true to enable application migrations and development within Azure. It considers all platform Resources that are required to support the customer's application portfolio and does not differentiate between IaaS or PaaS.

Every customers software estate will encompass a myriad of application archetypes and each Landing Zone essentially represents the common elements, such as networking and IAM, that are shared across instances of these archetypes and must be in place to ensure that migrating applications have access to requisite components when deployed. Each Landing Zone must consequently be designed and deployed in accordance with the requirements of archetypes within the customer's application portfolio.

The principle purpose of the "Landing Zones" is therefore to ensure that when an application lands on Azure, the required "plumbing" is already in place, providing greater agility and compliance with security and governance requirements.

---

_Using an analogy, this is similar to how city utilities such as water, gas, and electricity are accessible before new houses are constructed. In this context, the network, IAM, policies, management, and monitoring are shared 'utility' services that must be readily available to help streamline the application migration process._

---
