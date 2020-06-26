----
# ansible-role-app-envoy
Role for installing an Envoy edge proxy

## Required Variables
| Name | Type | Purpose |
| ---- | ------- | ----- |
| envoy_clusters | see below | upstream clusters that listeners can forward to |
| envoy_listeners| see below | how traffic is accepted and routed |

## Optional Variables
| Name | Type | Purpose |
| ---- | ------- | ----- |
| envoy_email_addr | string | Used when creating a `Let's Encrypt` certificate (see `envoy_generate_certificate`) |
| envoy_ulimit_nofile | int | used to pass `LimitNOFILE=N` to the Envoy unit file |

## Defaults
| Name | Type | Purpose | Value |
| ---- | ---- | ------- | ----- |
| envoy_admin_port | integer | where the admin UI listens | 9901 |
| envoy_dependencies | list(string) | packages to preinstall | see `defaults/main.yml` |
| envoy_etc_dir | string | where you install the config | `/etc/envoy` |
| envoy_generate_certificate | Boolean | whether to use Let's Encrypt to generate a certificate | false |
| envoy_max_files | int | sysctl limit for open files | 8192 |
| envoy_packages | list(string) | main package | `['getenvoy-envoy']` |
| envoy_publish_to_datadog | Boolean | choose whether to add Datadog config for Envoy | false |
| envoy_service | string | name of the Systemd service | `envoy.service` |
| envoy_state | string | state of the service | started |

## Cluster structure
List of dictionaries with the following keys:
| Name | Type | Purpose | Notes |
| ---- | ---- | ------- | ------- |
| name | scalar | label | na |
| http1only | Boolean | if true, omit http2_protocol_options from cluster | default=false |
| upstreams | list(dict(name, port)) | upstream endpoints and ports | na |
| circuit_breakers | list(dict(name, mc, mpr, mr)) | optional, mc=max_connections, mpr=max_pending_requests, mr=max_requests | na |

## Listener structure
List of dictionaries with the following keys:
| Name | Type | Purpose | Notes |
| ---- | ---- | ------- | ------- |
| cluster_name | string | name of the cluster (See above) to route traffic to | na |
| name | string | name of the listener | na |
| fqdn | string | fully qualified domain name | na |
| port | integer | where to listen | 8080 |
| sub_domains | list(string) | appended to fqdn to form domains list | [':443', ''] |
| use_tls | Boolean | if true, adds a tls_context section (pointing to Let's Encrypt certs) to a listener | default=true |

****
