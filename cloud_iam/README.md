## Documentation

- https://learn.microsoft.com/en-us/microsoft-365/
- https://cyber.gouv.fr/publications/recommandations-pour-la-securisation-de-la-mise-en-oeuvre-du-protocole-openid-connect
- https://cyber.gouv.fr/publications/recommandations-de-deploiement-dun-service-iaas-openstack-secnumcloud

## Core concepts

Compare against [Windows AD](../windows/active_directory) for the on-prem equivalents (Kerberos delegation ~ role assumption, ACL abuse ~ trust-policy misconfig).

### Workload identity federation (OIDC)

Modern default over long-lived static access keys: a workload (CI job, another cloud's service) presents a short-lived OIDC token from its own identity provider, which the cloud IAM trusts and exchanges for temporary credentials scoped to a role - no secret to leak/rotate.

- https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services # GitHub Actions -> AWS, same pattern for GCP/Azure
- https://cloud.google.com/iam/docs/workload-identity-federation

### AWS trust boundaries

- **Role assumption / trust policy**: a role's trust policy defines *who* (which principal) may assume it; a misconfigured trust policy (e.g. `"Principal": "*"` or an overly-broad account) lets unintended principals assume the role.
- **Confused deputy**: a more-privileged service (the "deputy") is tricked into acting on an attacker's behalf across account boundaries - mitigated with `sts:ExternalId` on cross-account trust policies. https://docs.aws.amazon.com/IAM/latest/UserGuide/confused-deputy.html
- **`iam:PassRole` privesc**: a principal that can `PassRole` an over-privileged role to a service it also controls (e.g. launch an EC2 instance/Lambda with that role attached) effectively gains that role's privileges. https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_passrole.html

## Cheatsheet

- https://cloud.hacktricks.xyz/welcome/readme
- https://github.com/lutzenfried/OffensiveCloud
- https://github.com/dafthack/CloudPentestCheatsheets

## Labs

- https://learn.microsoft.com/en-us/training/m365/
- https://github.com/iknowjason/Awesome-CloudSec-Labs

## Tools

- https://github.com/BishopFox/cloudfox
- https://github.com/RhinoSecurityLabs/Security-Research/tree/master/tools/aws-pentest-tools/s3

```bash
# --sublist3r depends on sublist3r, effectively unmaintained since ~2020 - prefer --subbrute or an external
# up-to-date enumerator (e.g. subfinder/amass) piped in if this flag stops working
./buckethead.py -d flaws.cloud -t 10 --sublist3r --subbrute
```

