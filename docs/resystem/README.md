# Resystem realm templates

This folder contains ready-to-import Keycloak realm JSON definitions for the Resystem platform. The templates align the realm layout (roles, groups, clients, and bootstrap users) with the Resystem separation between production and sandbox environments.

## Available realms

| File | Purpose |
| --- | --- |
| `realm-resystem-platform.json` | Primary realm for production Resystem workloads. |
| `realm-resystem-sandbox.json` | Sandbox realm intended for non-production validation and integration testing. |

Both realms follow the same structure so that access policies and tokens behave consistently between environments.

## Roles and groups

* **Realm roles**
  * `resystem-user` – baseline access used by all interactive users.
  * `platform-admin` – full administration of the Resystem realm and applications.
  * `operations` – operational/SRE access for runtime support activities.
  * `auditor` – read-only visibility to assist compliance reviews.
  * `tenant-admin` – delegated tenant administrator role.
  * `tenant-user` – standard tenant user role for business users.
  * `service` (production only) – service account role for automation and integration flows.
* **Group model**
  * `/platform-admins`, `/operations`, and `/auditors` bind the corresponding realm roles.
  * `/tenants/tenant-admins` and `/tenants/tenant-users` group tenant personnel with the correct baseline roles.
  * `/tenants/tenant-users` is the default group so every new account automatically inherits `tenant-user` and `resystem-user`.

## Clients

Each realm includes two preconfigured clients:

* **Administration console** (`resystem-console` or `resystem-console-sandbox`) – confidential client secured with PKCE, service accounts enabled, and redirect/back-channel URIs set to the matching environment host.
* **API** (`resystem-api` or `resystem-api-sandbox`) – bearer-only client that protects downstream services without issuing browser tokens.

Both clients attach the custom `resystem-groups` client scope so group paths and realm roles are available inside tokens for downstream authorization.

## Bootstrap users

The templates include starter users so administrators can log in immediately after importing:

* `bootstrap-admin` (production) and `sandbox-admin` (sandbox) are placed in `/platform-admins`.
* `tenant-admin` (production) and `sandbox-tenant` (sandbox) demonstrate tenant delegation.
* `tenant-user` (production) is pre-enrolled in `/tenants/tenant-users`.
* All bundled passwords are set to `CHANGE_ME` and flagged as temporary—users will be prompted to reset on first login.

## Importing the realms

1. Copy the appropriate JSON file to the host running Keycloak.
2. Start Keycloak with realm import enabled, for example:

   ```bash
   bin/kc.sh start-dev --import-realm --import-file=/path/to/realm-resystem-platform.json
   ```

3. After startup, verify that the `Resystem Platform` (or `Resystem Sandbox`) realm exists, groups are present, and the `resystem-groups` client scope appears under **Client scopes**.
4. Update the placeholder secrets (`CHANGE_ME`) and SMTP host values to match your environment.

The two realm files can be imported independently, allowing production and sandbox environments to stay aligned while keeping their credentials separate.
