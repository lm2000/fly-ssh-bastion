# Fly SSH Bastion

Minimal Fly.io bastion for a reverse SSH repair path to the existing Nora Intelligence System Hermes Cloud gateway.

This project does not deploy another Hermes Gateway.

## Design

- Fly.io runs only the small OpenSSH bastion.
- The existing Hermes Cloud gateway opens a reverse tunnel to the bastion.
- The operator connects through the bastion to the gateway over the reverse tunnel.
- Password and root login are disabled; public-key authentication is required.
