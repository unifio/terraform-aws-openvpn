# CHANGELOG

### ???

- Feature: Automatically push instance's subnet route into `server.conf`
- export `zone_id`, `dns_name` from aws_elb
- Fix the 4 subnet fixed mapping
- Fill in some examples

### 0.0.5
- Initial release of `generate-certs` module

### 0.0.4
- Standardization with other Unif.io OSS terraform modules
- CI Builder
- Small tweaks:
  - IAM roles are now `<stack_item_label>-<region>` instead of `<region>-<stack_item_label>`
  - Removed unused vars for user data.
  - ELB healthcheck on nodes.
  - lifecycle `create_before_destroy` fixes to deal with dependency issues on build.
  - somewhat breaking change: in_vpc now is `1`(true) instead of `0`(false)

### 0.0.3

- Fix: tag.application for elb reverted to using short name instead of full application name due to naming restrictions

### 0.0.2

- Fix: use updated `awscli` client from pip instead of apt

### 0.0.1

- Basic functioning openvpn server working off us-east-1

