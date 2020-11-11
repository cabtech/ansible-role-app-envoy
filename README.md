----
# ansible-role-app-envoy
Role for installing an Envoy edge proxy

## Required Variables
| Name | Type | Purpose |
| ---- | ------- | ----- |
| envoy_clusters | see below | upstream clusters that listeners can forward to |
| envoy_listeners| see below | how traffic is accepted and routed |

## Optional Variables
| Name | Type | Purpose | Comment |
| ---- | ------- | ----- | ------- |
| envoy_email_addr | string | Used when creating a `Let's Encrypt` certificate (see `envoy_generate_certificate`) ||
| envoy_extra_allow_headers | CSV | extra allowable headers to append to default set | e.g. 'grpc-encoding,content-encoding' | 
| envoy_ulimit_nofile | int | used to pass `LimitNOFILE=N` to the Envoy unit file ||

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
| Name | Status | Type | Purpose | Notes |
| ---- | ------ | ---- | ------- | ------- |
| name | required | string | label | na |
| circuit_breakers | optional | list(dict(name, mc, mpr, mr)) | optional, mc=max_connections, mpr=max_pending_requests, mr=max_requests | na |
| dns | optional | string | select DNS method to use | options=logical_dns(default),strict_dns |
| http2 | optional | Boolean | if true, include http2_protocol_options | default=true |
| upstreams | required | list(dict(name, port)) | upstream endpoints and ports | na |

## Listener structure
List of dictionaries with the following keys:
| Name | Type | Purpose | Notes |
| ---- | ---- | ------- | ------- |
| cluster_name | string | name of the cluster (See above) to route traffic to | na |
| name | string | name of the listener | na |
| fqdn | string | fully qualified domain name | na |
| full_domains | list(string) | added unaltered to domains list ||
| port | integer | where to listen | 8080 |
| sub_domains | list(string) | appended to fqdn and added domains list | e.g. [':443', ''] |
| use_tls | Boolean | if true, adds a tls_context section (pointing to Let's Encrypt certs) to a listener | default=true |

****
