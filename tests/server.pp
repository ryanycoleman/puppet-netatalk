netatalk::server { 'no-options': }
netatalk::server { '-':
    options => ['tcp', 'noddp']
}
netatalk::server { 'no-array':
    options => 'foobar' 
}
