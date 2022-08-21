# Azure Platform Naming Standards

## Description

This document is meant to provide details on the naming standards that are adopted for developing the Platform and Landing Zone managed Azure Resources.

---

**Important** This is list is expected to evolve over the lifecycle of the platform and should be updated when creating new resources.

---

## Name Segment Prefixes

| Key Used | Description                         | Example                                      |
| :------: | ----------------------------------- | -------------------------------------------- |
|  **A**   | Company Identifier Prefix           | sjt                                          |
|  **B**   | location/ Region Prefix             | syd, mel                                     |
|  **C**   | Platform Type Prefix                | idam, conn, mgmt, cor                        |
|  **C**   | Landing Zone Type Prefix            | nprd, dev, qa, tst, prd, ppd,                |
|  **D**   | Azure Resource Identifier Prefix    | See below                                    |
|  **E**   | unique identifier                   | GUID, number, alpha numeric text             |


## Naming Standard

| Resource Type                                    | Naming Prefix                  | Example                                   |                    Comments                    |
| ------------------------------------------------ | ------------------------------ | ----------------------------------------- | :--------------------------------------------: |
| Microsoft.Management/managementGroups            | **mg**-A                       | **mg**-landingzones-o-nprd                | See Management Group & Subscription Structure  |
| Microsoft.Resources/subscriptions                | **sub**-A-B-C-D-E-F            | **sub**-platform-all-nprd-prv-p-01        |                       -                        |
| Microsoft.Resources/resourceGroups               | **rg**-G-C-D-B-F               | **rg**-auea-nprd-prv-inthub-01            |                       -                        |
| Microsoft.Network/applicationSecurity Groups     | **asg**-G-C-D-B-F              | asg-auea-nprd-prv-dnsfwd-01               |                       -                        |
| Microsoft.Network/azureFirewalls                 | **azfw**-G-C-D-A-B-F           | azfw-auea-nprd-prv-platform-exthub-01     |                       -                        |
| Microsoft.Network/privateDnsZones                | B.A.C.D.E.az.police.nsw.gov.au | conn.pl.nprd.prv.p.az.police.nsw.gov.au   |  private link dns zones follow azure standard  |
| Microsoft.EventHub/namespaces                    | **eh**-G-C-D-A-B-F             | eh-auea-nprd-prv-platform-mgmt-01         |                       -                        |
| Microsoft.Network/firewallPolicies               | **fwp**-G-C-D-A-B-F            | fwp-auea-nprd-prv-platform-exthub-01      |                       -                        |
| Microsoft.Network/ipGroups                       | **ig**-AC-B                    | ig-iposNprd-AKS                           |                       -                        |
| Microsoft.KeyVault/vaults                        | **kv**-G-C-D-B-F               | kv-auea-nprd-prv-conn-01                  |                       -                        |
| Microsoft.OperationalInsights/workspaces         | **law**-G-C-D-B-F              | law-auea-nprd-prv-diagnostics-01          |    production doesn't use env. domain (pr)     |
| Microsoft.Network/localNetworkGateways           | **lng**-G-C-D-A-B-F            | lng-auea-nprd-prv-platform-inthub-01      |                       -                        |
| Microsoft.Network/localNetworkGateways           | **nsg**-(sn-G-C-D-A-B-F)       | nsg-sn-auea-nprd-prv-platform-dnsfwd-01   |        (sn): if NSG is bound to subnet         |
| Microsoft.Network/privateEndpoints               | **pe**-F-X                     | pe-01-kv-auea-nprd-prv-conn-01            |      X: Resource Name that PE belongs to       |
| Microsoft.Network/networkInterfaces              | **nic**-X-F                    | nic-ppwcazdns02-01                        |        private link NIC follows PE name        |
| Microsoft.Storage/storageAccounts                | **sa**gcdab                    | saaueanprdprvplatconnnfl                  |            name governed by limits             |
| Microsoft.Network/virtualNetworks                | **vn**-G-C-D-A-B-F             | vn-auea-nprd-prv-platform-inthub-01       |                       -                        |
| Microsoft.ManagedIdentity/userAssignedIdentities | **ui**-X                       | ui-fwp-auea-nprd-prv-platform-exthub-01   |                       -                        |
| Microsoft.Network/publicIPAddresses              | **pip**-X                      | pip-azfw-auea-nprd-prv-platform-exthub-01 |                       -                        |
| Microsoft.RecoveryServices/vaults                | **rsv**-G-C-D-B-F              | rsv-auea-nprd-prv-conn-01                 |                       -                        |
| Microsoft.Network/routeTables                    | **rt**-(sn-G-C-D-A-B-F)        | rt-sn-auea-nprd-prv-platform-dnsfwd-01    |                       -                        |
| Microsoft.Network/virtualNetworkGateways         | **vpngw / ergw**-G-C-D-A-B-F   | vpngw-auea-pr-prd-platform-inthub-01      |          gateway can be ergw or vpngw          |
| Microsoft.Compute/disks                          | **disk**-B-X                   | disk-os-ppwcaznpddns01                    |                  B: os, data                   |