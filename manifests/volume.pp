# Define: netatalk:::volume
#
# This module shares out netatalk volumes
#   Home volumes are shared by default
#
# Parameters:
#   path        = path of volume to share out (path)
#   volume_name = name to advertise for shared volume (string)
#   options     = options for shared volume (string)
#   order       = order of entry in config, relative to others.
#                 defaults to 02, main config is 01
#
# Actions:
#   Adds an entry to AppleVolumes.default
#   Refreshes the netatalk service
#
# Sample Usage:
#
#   netatalk::volume { 'software':
#     path => '/Applications',
#   }
#
define netatalk::volume (
  $path,
  $volume_name=$name,
  $options=undef,
  $order='02'
) {

  include netatalk

  validate_re($path, '^/.*')
  validate_string($volume_name)
  if $options != undef {
    validate_string($options)
  }

  concat::fragment { $name:
    target  => $netatalk::params::volumes_config,
    content => "${path} \"${volume_name}\" ${options}\n",
    order   => $order,
    notify  => Service[$netatalk::params::service_name],
  }

}
