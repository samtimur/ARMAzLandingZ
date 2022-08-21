# Deploy the Azure Foundations Reference implementation

This section will guide you through the process of deploying the Azure Foundations reference implementation into an environment.

## What is Reference Implementation?

Azure Foundations design principles and implementation can be adopted by all customers no matter what size and history their Azure estate. The following reference implementations target different and most common customer scenarios for cloud adoption.

## Deploy Reference Implementation

| Reference Implementation | Description | ARM Template | Link |
|:-------------------------|:-------------|:-------------|------|
| Perth | Platform subscription deployment for Identity, Management and Networking resources (Traditional Hub & Spoke deployment pattern) |[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2Ftulpy%2FAzureFoundations%2FMaster%2FarmTemplates%2Fhub.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Ftulpy%2FAzureFoundations%2FMaster%2FarmTemplates%2Fportal-hub.json) | [Detailed description](./docs/reference/contoso/Readme.md) |
| Barcelona | Application Landing Zone deployment for workloads (Spoke deployment pattern) |[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2Ftulpy%2FAzureFoundations%2FMaster%2FarmTemplates%2Fspoke.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Ftulpy%2FAzureFoundations%2FMaster%2FarmTemplates%2Fportal-spoke.json) | [Detailed description](./docs/reference/adventureworks/README.md) |
| Hong Kong | Platform subscription deployment for Identity, Management and Networking resources (Azure vWAN deployment pattern) | Coming Soon! | Coming Soon!|

>Once the deployment is complete, please ensure required platform subscriptions are moved under the `Platform` Management Groups if you have not done so as a part of deployment.

Azure Foundations reference implementation is rooted in the principle that **Everything in Azure is a Resource**. All reference customers scenarios leverage native **Azure Resource Manager (ARM)** to describe and manage their resources as part of their target state architecture at-scale.

Reference implementations enables security, monitoring, networking, and any other plumbing needed for landing zones (i.e. Subscriptions) autonomously through policy enforcement. Companies will deploy the Azure environment with ARM templates to create the necessary structure for management and networking to declare a desired goal state. All scenarios will apply the principle of "Policy Driven Governance" for landing zones using policy. The core benefits of a policy-driven approach are manyfold but the most significant ones are:

1. Platform can provide an orchestration capability to bring target Resources (in this case a subscription) to a desired goal state.
2. Continuous conformance to ensure all platform-level Resources are compliant. Because the platform is aware of the goal state, the platform can assist with the monitoring and remediation of Resources throughout their life-cycle.
3. Platform enables autonomy regardless of the customer's scale point.
