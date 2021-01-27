----
# ansible-role-app-envoy
Role for installing an Envoy edge proxy

## Required Variables
| Name | Type | Purpose |
| ---- | ------- | ----- |
| envoy_clusters | list(dict()) | upstream clusters that listeners can forward to |
| envoy_listeners| list(dict()) | how traffic is accepted and routed |

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
| Name | Type | Status | Comments |
| ---- | ---- | ------ | -------- |
| name | string | required | primary key |
| circuit_breakers | list(dict(name, mc, mpr, mr)) | optional | mc=max_connections, mpr=max_pending_requests, mr=max_requests |
| connection_buffer_size | integer | optional | sets perConnectionBufferLimitBytes |
| dns | string | optional | select DNS method to use | options=logical_dns(default),strict_dns |
| http2 | Boolean | optional | if true, include http2_protocol_options | default=true |
| upstreams | list(dict(name, port)) | required | upstream endpoints and ports | na |

## Listener structure
List of dictionaries with the following keys:
| Name | Type | Purpose | Comments |
| ---- | ---- | ------- | -------- |
| name | string | name of the listener | primary key |
| cluster_name | string | name of the cluster to route traffic to | none |
| connection_buffer_size | integer | optional | sets perConnectionBufferLimitBytes |
| fqdn | string | fully qualified domain name | none |
| full_domains | list(string) | added unaltered to domains list | none |
| port | integer | where to listen | default 8080 |
| sub_domains | list(string) | appended to fqdn and added domains list | e.g. [':443', ''] |
| use_tls | Boolean | if true, adds a tls_context section to a listener | default true |

****
