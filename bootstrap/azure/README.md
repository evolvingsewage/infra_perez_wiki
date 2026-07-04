# bootstrap/azure — not yet built

Creates the Azure resources needed to hold Terraform state for
`azure/monitoring`:

- Resource group for state storage
- Storage Account (encrypted by default) + blob container for remote state

Applied once, manually, with **local** state (same chicken-and-egg reason as
`bootstrap/aws`). After this runs once, its outputs (storage account name,
container name) get wired into `azure/monitoring`'s backend config.
