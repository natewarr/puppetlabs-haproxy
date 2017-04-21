# == Define Resource Type: haproxy::resolvers
#
# This type will setup a resolvers configuration block inside
#  the haproxy.cfg file on an haproxy load balancer.
#
# === Parameters
#
# [*name*]
#   The namevar of the defined resource type is the resolvers block name
#
# [*nameservers*]
#   Required. Array of strings to create nameservers inside the resolvers block.
#   Entries should match the format: <name> <ip_address>:<port>
#    $nameservers => ["ns1 10.0.0.1:53","ns2 10.0.1.1:53"]
#
# [*holds*]
#   Array of strings to create holds inside the resolvers block
#     $holds => ['valid 10s', 'other 30s', 'refused 30s', 'nx 30s', 'timeout 30s']
#
# [*resolve_retries*]
#   Number of queries to send to resolve a server before giving up
#     $resolve_retries => 3
#
# [*timeouts*]
#   Array of strings to create timeouts inside the resolvers block
#     $timeouts => ['retry 1s']
#
# === Authors
#
# Nate Warren <Github: natewarr>
#
define haproxy::resolvers (
  $nameservers,
  $holds            = [],
  $resolve_retries  = undef,
  $timeouts         = [],
) {

  validate_array($nameservers)
  validate_array($holds)
  validate_array($timeouts)

  # Template uses: $name, $nameservers, $holds, $timeouts, $resolve_retries
  concat::fragment { "${name}_resolvers_block":
    order   => "19-${name}-00",
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/haproxy_resolvers_block.erb'),
  }
}
