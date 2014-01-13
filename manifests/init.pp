# Class: netatalk
#
# This class manages netatalk
#
# Parameters:
#   none.
#   File,Package,Service params are set in netatalk::params
#
# Actions:
#  This class establishes a netatalk (afp) service by
#    * Installing the netatalk package
#    * Delivering a default netatalk config
#    * Establishing the netatalk service
#
# Requires:
#  The concat module by RI Pienaar
#
# Sample Usage:
#   include netatalk
class netatalk(
    $share_home_directories = true ,
    $volume_defaults        = undef ,
  ) {

  include concat::setup
  include netatalk::params

  package { $netatalk::params::package_name:
    ensure => present,
  }

  file { $netatalk::params::config_dir:
    ensure  => directory,
    require => Package[$netatalk::params::package_name],
    notify  => Service[$netatalk::params::service_name],
  }

  file { $netatalk::params::global_config:
    ensure => file,
    content => template('netatalk/netatalk.conf.erb'),
    require => Package[$netatalk::params::package_name],
    notify  => Service[$netatalk::params::service_name],
  }

  service { $netatalk::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  concat { 'volumes':
    name  => $netatalk::params::volumes_config,
    owner => 'root',
    group => 'root',
  }

  concat { 'servers':
    name  => $netatalk::params::afpd_config,
    owner => 'root',
    group => 'root',
  }

  if $volume_defaults {
    $_volume_defaults = $volume_defaults
  }
  else {
    $_volume_defaults = $netatalk::params::volume_defaults
  }
  $_volume_defaults_config = "# The line below sets some DEFAULT, starting with Netatalk 2.1.\n:DEFAULT:${_volume_defaults}\n"

  if $share_home_directories {
    $_share_home_directories_config = "# By default all users have access to their home directories.\n~/			\"Home Directory\"",
  } else {
    $_share_home_directories_config = ''
  }

  concat::fragment { 'volumes_default':
    target => $netatalk::params::volumes_config,
    source => 'puppet:///modules/netatalk/AppleVolumes.default',
    order => '00',
  }

  concat::fragment { 'volumes_default_settings':
    target => $netatalk::params::volumes_config,
    content => "\n${_volume_defaults_config}\n${_share_home_directories_config}\n",
    order => '01',
  }

  concat::fragment { 'afpd_conf':
    target => $netatalk::params::afpd_config,
    source => 'puppet:///modules/netatalk/afpd.conf',
    order => '01',
  }

}
