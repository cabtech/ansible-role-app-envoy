----
# ansible-role-app-envoy
Role for installing Envoy Proxy

## Required Variables
| Name | Type | Purpose |
| ---- | ------- | ----- |
| envoy_cluster_name | string | names the cluster that will use var(envoy_upstreams) |
| envoy_fqdn | string | onboarding-dev.example.com |
| envoy_upstreams | list(dict(keys(name, port))) | tells Envoy about upstream connections for var(envoy_cluster_name) |

## Option Variables
| Name | Type | Purpose |
| ---- | ------- | ----- |
| envoy_email_addr | string | Used when creating a Let's Encrypt certificate (see `envoy_generate_certificate`) |

## Defaults
| Name | Purpose | Value |
| ---- | ------- | ----- |
| envoy_admin_port | where the admin UI listens | 9901 |
| envoy_dependencies | packages to preinstall | see `defaults/main.yml` |
| envoy_etc_dir | where you install the config | `/etc/envoy` |
| envoy_generate_certificate | whether to use Let's Encrypt to generate a certificate | false |
| envoy_packages | main package | `['getenvoy-envoy']` |
| envoy_publish_to_datadog | choose whether to add Datadog config for Envoy | false |
| envoy_service | name of the Systemd service | `envoy.service` |
| envoy_state | state of the service | started |

## To Do
- support multiple listeners

****
