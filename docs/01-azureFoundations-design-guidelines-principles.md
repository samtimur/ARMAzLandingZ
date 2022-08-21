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

## Design Guidelines

At the centre of the Azure Foundations architecture lies a critical design path, comprised of fundamental design topics with heavily interrelated and dependent design decisions. This repository provides design guidance across these architecturally significant technical domains to support the critical design decisions which must occur to define the Azure Platform architecture. For each of the considered domains, readers should review provided considerations and recommendations, using them to structure and drive designs within each area.

### Critical Design Areas

The following eight critical design areas are intended to support the translation of customer requirements to Azure constructs and capabilities, to address the mismatch between on-premises infrastructure and cloud-design which typically creates dissonance and friction with respect to the definition and Azure adoption.

The impact of decisions made within these critical areas will reverberate across the Azure Foundations architecture and influence other decisions. Readers are strongly advised to familiarize themselves with these eight areas, to better understand the consequences of encompassed decisions, which may later produce trade-offs within related areas.

* [A - Enterprise Enrollment and Azure AD Tenants](./A-Enterprise-Enrollment-and-Azure-AD-Tenants.md)
* [B - Identity and Access Management](./B-Identity-and-Access-Management.md)
* [C - Management Group and Subscription Organization](./C-Management-Group-and-Subscription-Organization.md)
* [D - Network Topology and Connectivity](./D-Network-Topology-and-Connectivity.md)
* [E - Management and Monitoring](./E-Management-and-Monitoring.md)
* [F - Business Continuity and Disaster Recovery](./F-Business-Continuity-and-Disaster-Recovery.md)
* [G - Security, Governance and Compliance](./G-Security-Governance-and-Compliance.md)
* [H - Platform Automation and DevOps](./H-Platform-Automation-and-DevOps.md)

## Design Principles

The Azure Foundations architecture prescribed in this playbook is based on the design principles described in this section. These principles serve as a compass for subsequent design decisions across critical technical domains. Readers are strongly advised to familiarize themselves with these principles to better understand their impact and the trade-offs associated with non-adherence.

### Subscription Democratization

Subscriptions should be used as a unit of management and scale aligned with business needs and priorities, to support business areas and portfolio owners to accelerate application migrations and new application development. Subscriptions should be provided to business units to support the design and development/testing of new workloads and migration of workloads.

### Policy Driven Governance

Azure Policy should be used to provide the **guard-rails** and ensure the continued compliance of the customer platform and applications deployed onto it, whilst also providing application owners sufficient freedom and a secure unhindered path to cloud.

### Single Control and Management Plane

The Azure Foundations architecture should not consider any abstraction layers such as customer developed portals or tooling and should provide a consistent experience for both AppOps (centrally managed operation teams) and DevOps (dedicated application operation teams). Azure provides a unified and consistent control plane across all Azure resources and provisioning channels which should be used to establish a consistent set of policies and controls for governing the entire customer estate, subject to RBAC and policy driven controls.

### Application Centric and Archetype-Neutral

The Azure Foundations architecture should focus on application centric migrations and development rather than a pure infrastructure "lift and shift" migration (i.e. movement of virtual machines) and should not differentiate between old/new applications or IaaS/PaaS applications. Ultimately, it should provide the foundation for all application types to be deployed onto the customer Azure platform securely and safely.

### Azure Native Design and Roadmap Aligned

The **Enterprise Scale architecture** approach advocates the use of native platform services and capabilities whenever possible, which should be aligned with Azure platform roadmaps to ensure new capabilities are made available within customer environments. Azure platform roadmaps should help inform the migration strategy.

### Recommendations

* Be prepared to trade off functionality as not everything will likely be required on day one.
* Leverage preview services and take dependencies on service roadmaps in order to remove technical blockers.
