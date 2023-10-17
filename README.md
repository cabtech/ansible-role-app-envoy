----
# ansible-role-app-envoy
Role for installing an [Envoy](https://www.envoyproxy.io/) proxy

## Default Variables
| Name | Type | Value | Comment |
| ---- | ---- | ----- | ------- |
| envoy_admin_port | integer | 9901 | where the admin UI listens |
| envoy_certbot_domain_file | UnixPath | /etc/envoy/domains.txt | iff envoy_certbot_domain_names is set, generate file to pass to `manage-letencrypt.sh` |
| envoy_cfg_dir | string | `/etc/envoy` | where you install the config |
| envoy_clusters | list(dict) | [] | see below on how to define upstreams |
| envoy_dependencies | list(string) | see `defaults/main.yml` |  packages to preinstall per Linux family |
| envoy_dirs | list(dict) | see `defaults/main.yml` |  directories to add |
| envoy_generate_certificate | Boolean | false | whether to use [Let's Encrypt](https://letsencrypt.org/) to generate a certificate |
| envoy_listeners | list(listener) | [] | see below on how to define listeners |
| envoy_log_dir | UnixDir | `/var/log/envoy` | where the logs go |
| envoy_log_file | UnixFile | `envoy.log` | log file in envoy_log_dir |
| envoy_max_files | integer | 8192 | sysctl limit for open files |
| envoy_packages | list(string) | see `defaults/main.yml` | main Envoy package |
| envoy_proxy_style | string | `edge_proxy` | see Examples section below |
| envoy_publish_to_datadog | Boolean | false | choose whether to add Datadog config for Envoy |
| envoy_repo | dict(dict) | see `defaults/main.yml` | where to find the Envoy repo and its signing keys |
| envoy_svc_enabled | Boolean | true | should the service start at boot |
| envoy_svc_name | string | envoy | name of the Systemd service |
| envoy_svc_state | SystmedState | started | state of the service |
| envoy_tls_ca | UnixPath | `/etc/ssl/certs/ca-certificates.crt` ||

## Optional Variables
| Name | Type | Comment |
| ---- | ------- | ------- |
| envoy_certbot_domain_names | list(string) | used to render `envoy_certbot_domain_file` |
| envoy_email_addr | string | Used when creating a [Let's Encrypt](https://letsencrypt.org/) certificate (see `envoy_generate_certificate`) |
| envoy_extra_allow_headers | CSV | extra allowable headers to append to default set | e.g. 'grpc-encoding,content-encoding' |
| envoy_tls_certchain | UnixPath | example `/etc/letsencrypt/live/example.com/fullchain.pem` |
| envoy_tls_prikey | UnixPath | example `/etc/letsencrypt/live/example.com/privkey.pem` |
| envoy_ulimit_nofile | integer | used to pass `LimitNOFILE=N` to the Envoy unit file |

## Cluster structure
List of dictionaries with the following keys:
| Name | Status | Type | Purpose | Notes |
| ---- | ------ | ---- | ------- | ------- |
| name | required | string | label | na |
| circuit_breakers | optional | list(dict(name, mc, mpr, mr)) | optional, mc=max_connections, mpr=max_pending_requests, mr=max_requests | na |
| dns | optional | string | select DNS method to use | options=logical_dns(default),strict_dns |
| http2 | optional | Boolean | if true, include http2_protocol_options | default=true |
| upstreams | required | list(dict(name, port)) | upstream endpoints and ports | na |

## `listener` structure
List of dictionaries with the following keys:
| Name | Type | Default | Comments |
| ---- | ---- | ------- | -------- |
| cluster_name | string | na | name of the cluster (See above) to route traffic to |
| name | string | na | name of the listener |
| fqdn | string | na | fully qualified domain name |
| full_domains | list(string) | na | added unaltered to domains list |
| port | integer | na | port to listen on |
| sub_domains | list(string) | na | appended to fqdn and added domains list, e.g. [':443', ''] |
| use_tls | Boolean | true | if true, adds a `tls_context` section (pointing to your cert and prikey) to a listener |
| vhosts | list(vhost) | [] ||
| websocket | Boolean | false | if true, adds `upgrade_configs` section |

## `vhost` structure
| Name | Type | Comments |
| ---- | ---- | -------- |
| allow_headers | string | CSV of allowable headers (overrides listener settings) |
| allow_methods | string | CSV of allowable methods (overrides listener settings) |
| cluster_name | string | xref(envoy_clusters[].name |
| fqdn | string | na | fully qualified domain name |
| name | string | unique per listener |
| sub_domains | list(string) | na | appended to fqdn and added domains list, e.g. [':443', ''] |

## Certificates
If you want to use [Let's Encrypt](https://letsencrypt.org) certificates with your proxy, it's easier to create them first and then set `envoy_tls_certchain` and `envoy_tls_prikey`.

## Examples
There are two styles of proxy controlled by the `envoy_proxy_style` variable.

### Edge Proxy
You would use this if you have, say, an AWS ALB infront of everything.  You would use listener rules in the ALB to route traffic to N listeners each of which has a 1 vhost pointing to a cluster.
```
# TODO Example
envoy_proxy_style: edge_proxy
```

### External Proxy
Use this if you have a proxy directly facing the Internet.  You'll just have 1 listener (usually on port 443) and use N vhosts, each of which points to a cluster
```
# Grafana example
envoy_proxy_style: external
envoy_tls_certchain: /etc/letsencrypt/live/example.com/fullchain.pem
envoy_tls_prikey: /etc/letsencrypt/live/example.com/privkey.pem

envoy_clusters:
- {name:  grafana, dns: STRICT_DNS, upstreams: [{name: "127.0.0.1", port: 3000}]}

envoy_listeners:
- name: main
  add_redirect: true
  port: 443
  use_tls: true
  vhosts:
  - name: grafana
    cluster_name: grafana
    fqdn: "example.com"
    sub_domains: [":443", ""]

```
****
