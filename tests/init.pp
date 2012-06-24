netatalk::volume { 'Temp':
  path => '/tmp',
}
netatalk::volume { 'Home':
  path => '~',
  volume_name => '\"Home Directory\"',
}
