puppet-launchd
=============

A Puppet module for managing LaunchDaemons and LaunchAgents.

``` puppet
launchd::job {'com.company.example':
    ensure                  => 'present',
    program                 => '/usr/local/bin/my_script.py',
    start_calendar_interval => {'Hour' => 1, 'Minute' => 15 },
}
