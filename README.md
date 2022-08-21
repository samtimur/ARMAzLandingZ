# Azure Foundations - Reference Implementation

## Navigation Menu

* [Azure Foundations Architecture](./docs/azureFoundations-architecture.md)
* [Configure Azure permission for ARM Template deployments](./docs/azureFoundations-setup-azure.md)
* [Deploy Reference Implementation](./docs/azureFoundations-deploy-reference-implentations.md)
  * [Create Landing Zones](./docs/azureFoundations-deploy-landing-zones.md)
* [FAQ](./docs/azureFoundations-FAQ.md)
* [[Optional] Getting started with Infrastructure-as-code](./docs/Deploy/getting-started.md)
  * [Configure Azure permissions for ARM tenant deployments & setup GitHub](./docs/Deploy/setup-github.md)
  * [Initialize Git with current Azure configuration](./docs/Deploy/discover-environment.md)
  * [Deploy your own ARM templates with AzOps GitHub Actions](./docs/Deploy/deploy-new-arm.md)
  * [Configure Azure DevOps support](./docs/Deploy/setup-azuredevops.md)
* [Enterprise-Scale "in-a-box" tutorial](./docs/enterprise-scale-iab/README.md)


---
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

The Azure Foundations architecture is modular by design and allows customers to start with foundational Landing Zones that support their application portfolios, regardless of whether the applications are being migrated or are newly developed and deployed to Azure. The architecture can scale alongside the customer's business requirements regardless of scale point. In this repository we are providing the following three templates representing different scenarios composed using ARM templates.

| Code Name | Description | Deployment Topology | Deployment Type |
|:----------|:------------|:--------------------|:----------------|
| Split | Single Azure Platform subscription for Identity, Management and Network Connectivity resources | Traditional Hub & Spoke & vWAN deployment pattern |[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FInsight-Services-APAC%2Fazure-landing-zones%2Fmaster%2Freference%2Fsplit%2Fmain.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FInsight-Services-APAC%2Fazure-landing-zones%2Fmaster%2Freference%2Fsplit%2Fportal.json) | |
| Barcelona | Multiple Azure Platform subscription for Identity, Management and Network Connectivity resources | Traditional Hub & Spoke & vWAN deployment pattern |[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FInsight-Services-APAC%2Fazure-landing-zones%2Fmaster%2Freference%2Fbarcelona%2Fmain.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FInsight-Services-APAC%2Fazure-landing-zones%2Fmaster%2Freference%2Fbarcelona%2Fportal.json) |

## Conditions for success

To fully leverage this reference architecture, there must be a collaborative engagement with key customer stakeholders across critical technical domains, such as identity, security, and networking. Ultimately, the success of cloud adoption hinges on cross-discipline cooperation within the organization, since key pre-requisite design decisions are cross cutting, and to be authoritative must involve domain Subject Matter Expertise (SME) and stakeholders within the customer. It is crucial that the organization has defined their [Azure Foundations Architecture](./docs/azureFoundations-architecture.md) following the design principles and critical design areas.

It is also assumed that readers have a broad understanding of key Azure constructs and services in order to fully contextualize the prescriptive recommendations contained within this architecture.
