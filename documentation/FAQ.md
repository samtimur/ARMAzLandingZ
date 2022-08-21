## FAQ

This page will list frequently asked question for the Enterprise-Scale reference implementations.

### What does "Landing Zone" map to in Azure in the context of Enterprise-Scale?

From Enterprise-Scale point of view, subscriptions are the "Landing Zones" in Azure.

### Why do Enterprise-Scale ARM templates require permission at Tenant root '/' scope?

Management Group creation, Subscription creation, and Subscription placement into Management Groups are APIs that operates at the tenant root (/). So in order to create the management group hierarchy, the subscriptions, and organize them accordingly into the management groups, the initial deployment must also be invoked at the tenant root (/) scope.
Once you have deployed Enterprise-Scale, you can remove the Owner permission from the tenant root (/) scope, as you will be Owner at the intermediate root management group that Enterprise-Scale is creating.

### Why are there custom policy definitions as part of Enterprise-Scale Landing Zones?

We work with - and learn from our customers and partners, and ensures that we evolve and enhance the reference implementations to meet customer requirements. The primary approach of the policies as part of Enterprise-Scale is to be proactive (deployIfNotExist, and modify), and preventive (deny), and we are continiously moving these policies to built-ins.

### What does Policy Driven Governance means, and how does it work?

Azure Policy and deployIfNotExist enables the autonomy in the platform, and reduces the operational burden as you scale your deployments and subscriptions in the Enterprise-Scale architecture. The primary purpose is to ensure that subscriptions and resources are compliant, while empowering application teams to use their own preferred tools/clients to deploy.
Some examples:

* A new subscription (landing zone) is created and placed into the targeted management group (online, corp, sandbox etc.). Azure Policy will then ensure that Azure Security Center is enabled for the subscription, the diagnostic setting for the Activity Log is routed to the platform Log Analytics Workspace, budget is applied, and virtual network peering is done properly back to the connectivity subscription. Instead of repeating and duplicating code and efforts when a new subscription is being created, Azure Policy is assigned at the management group to automatically bring the subscriptions into their compliant goal state.

* An application team is deploying a workload composed of SQL Databases, Virtual Machines, Network Security Groups, and Load Balancers into their landing zone. Azure Policy will ensure that all these resources have the right logging and security enabled from a platform perspective (e.g., NetworkSecurityGroupEvent log category for Network Security Group is routed to the platform Log Analytics workspace, Azure Monitor VM Extensions are added to the Virtual Machine, auditing is enabled for the SQL Database).

### Are we supposed to use Azure Policy for workload deployments?

The short answer to this is: No.
Azure Policy is not doing workload deployments, but ensures workloads that are being deployed (regardless of *how*) will be compliant per the organization's security and compliance requirements. Also, it ensures application teams can chose their preferred tooling and clients for deployments, instead of relying on central IT to provide artifacts, pipelines, tools etc.

### What if I already have resources in my landing zones, and later add a policy?

This is very common, and expected as new Azure services are being enabled and used, and you need to govern them. When assigning a policy to a scope (management group) that contains subscriptoins with resources subject to that policy, the assignment will start an initial *scan* of the scope, and report on compliant and non-compliant resources. Depending on the policy effect (deny, audit, append, modify, deployIfNotExist, and auditIfNotExist), you can remediate and bring the resources into a compliant state automatically.

Once a policy is assigned, it will take immediate effect for all new *writes* (create/update) to that scope subject to the policy rule.
Example:

* Assigning a policy that deploys Azure Monitor VM extension to a management group containing subscriptions with virtual machines, will detect all virtual machines that does not have the Azure Monitor VM extenstion enabled, and mark them as non-compliant. These virtual machines can now be remediated so the Azure Monitor VM extension gets enabled, and the virtual machines will be compliant.

* For all new VM create/update requests to those subscriptions subject to the policy, the policy will act as soon as the VM create request has completed successfully, and there is no need to remediate or take any actions.

### Where can I see the policies used by Enterprise-Scale Landing Zones reference implementation?

We maintain the index [here](./ESLZ-Policies.md), and will update the tables when:

* A custom policy is moved to built-in policy
* When a custom policy is deprecated
* When there's a major update to a policy definition/ policy set definition
* When we update the reference implementations to assign new/existing built-in policies as part of the deployment