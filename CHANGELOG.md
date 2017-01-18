## Unreleased

## 0.1.0

#### BREAKING CHANGES:

- Removed `\` backslash escapes. Breaks compatibility with Terraform versions < 0.8.0

#### IMPROVEMENTS:

- Feature: Automatically push instance's subnet route into `server.conf`
- export `zone_id`, `dns_name` from aws_elb
- Fix the 4 subnet fixed mapping
- Fill in some examples
- Update modules to use terraform 0.8.x syntax

## 0.0.8

#### IMPROVEMENTS:
- [#6]: (certs) - Simplify logic when specifying a custom ami.
- [#7]: (generate-certs) - Terraform 0.7.x compatibility updates.
- [#7]: (certs) - Terraform 0.7.x compatibility updates.

## 0.0.7

#### BUG FIXES:
- Resolved regression in certificate generator user data template.

## 0.0.6

#### BREAKING CHANGES:
- Updates in resource naming will cause churn for existing resources.
- Updated certificate generator to require VPC deployment

#### IMPROVEMENTS:
- Standardization with other Unif.io OSS terraform modules
- Documentation improvements
- Updated security group scheme for OpenVPN server
- Added pre-built AMI lookup to the server module

## 0.0.5

#### FEATURES:
- Initial release of `generate-certs` module

## 0.0.4

#### IMPROVEMENTS:
- Standardization with other Unif.io OSS terraform modules
- CI Builder
- Small tweaks:
  - IAM roles are now `<stack_item_label>-<region>` instead of `<region>-<stack_item_label>`
  - Removed unused vars for user data.
  - ELB healthcheck on nodes.
  - lifecycle `create_before_destroy` fixes to deal with dependency issues on build.
  - somewhat breaking change: in_vpc now is `1`(true) instead of `0`(false)

## 0.0.3

#### IMPROVEMENTS:
- Fix: tag.application for elb reverted to using short name instead of full application name due to naming restrictions

## 0.0.2

#### IMPROVEMENTS:
- Fix: use updated `awscli` client from pip instead of apt

## 0.0.1

#### FEATURES:
- Basic functioning openvpn server working off us-east-1
