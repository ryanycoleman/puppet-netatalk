class netatalk::params {

  $package_name = 'netatalk'
  $service_name = 'netatalk'
  $afp_service = true
  $afp_port    = '548'

  case $::operatingsystem {

    'centos', 'redhat', 'fedora', 'scientific': {
      $config_dir = '/etc/netatalk'
      $global_config = "${config_dir}/netatalk.conf"
      $volumes_config = "${config_dir}/AppleVolumes.default"
    }

    'ubuntu', 'debian': {
      $config_dir = '/etc/netatalk'
      $global_config = '/etc/default/netatalk'
      $volumes_config = "${config_dir}/AppleVolumes.default"
    }

    default: {
      fail("The ${module_name} module only supports EL variants, Ubuntu and Debian. Check the modules documentation for details")
    }

  }

}
