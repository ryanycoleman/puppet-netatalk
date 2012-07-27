# Define: netatalk:::server
#
# This module configures afpd servers
#
# Parameters:
#   server_name = name to advertise for shared server (string)
#   options     = options for shared server (array)
#   order       = order of entry in config, relative to others.
#                 defaults to 02, main config is 01
#
# Actions:
#   Adds an entry to afpd.conf 
#   Refreshes the netatalk service
#
# Sample Usage:
#
#   netatalk::server { '-':
#    options => ['tcp', 'noddp']
#   }
#
define netatalk::server (
  $server_name=$name,
  $options=undef,
  $order='02'
) {

  include netatalk

  validate_string($server_name)
  if $options != undef {
      validate_array($options)
      $options_string = join($options, ' -')
  }

  concat::fragment { $name:
    target  => $netatalk::params::afpd_config,
    content => "${server_name} ${options_string}\n",
    order   => $order,
    notify  => Service[$netatalk::params::service_name],
  }

}
