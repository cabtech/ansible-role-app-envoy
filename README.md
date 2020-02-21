----
# ansible-role-app-envoy
Role for installing Envoy Proxy

## Defaults
| Name | Purpose | Value |
| ---- | ------- | ----- |
| envoy_admin_port | where the admin UI listens | 9901 |
| envoy_dependencies | packages to preinstall | see `defaults/main.yml` |
| envoy_etc_dir | where you install the config | /etc/envoy |
| envoy_packages | main package | ['getenvoy-envoy'] |
| envoy_publish_to_datadog | choose whether to add Datadog config for Envoy | false |
| envoy_service | name of the Systemd service | envoy.service |
| envoy_state | state of the service | started |

****
