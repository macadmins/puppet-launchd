# == Define: launchd::job
#
# Configures launchd items on OS X (LaunchAgents and LaunchDaemons).
# For more information on LaunchD, see http://launchd.info
#
# === Parameters
#
# [*ensure*]
#   Whether the LaunchD item is present or absent. Defaults to present.
#
# [*name*]
#   The reverse domain of the launchd item. If not specified, the namevar is used.
#   Used as the label in the launchd plist
#
# [*type*]
#   Whether this is a LaunchAgent or LaunchDaemon. Defaults to deamon, also accepts agent.
#
# [*source*]
#   A launchd property list file. Can exist on disk or be transfered with pluginsync.
#   Can not be used in conjuntion with content.
#
# [*content*]
#   A launchd property list string. Can be passed directly or from a template.
#   Can not be used in conjunction with source. Type: String.
#
# [*disabled*]
#   Instructs launchd to not attempt to load the plist. Type: Boolean. Defaults to false.
#
# [*program*]
#   Your launchd command. Type: String.
#
# [*program_arguments*]
#   Your multiple option command. Type: Array.
#
# [*environment_variables*]
#   Set environment variables. Type: Hash.
#
# [*standard_in_path*]
#   Redirect stdin. Relative paths are interpreted relative to root_directory or /. Type: String.
#
# [*standard_out_path*]
#   Redirect stdout. Relative paths are interpreted relative to root_directory or /. Type: String.
#
# [*standard_error_path*]
#   Redirect stderr. Relative paths are interpreted relative to root_directory or /. Type: String.
#
# [*working_directory*]
#   Use this key to set your programs working directory.
#   Every relative path the executable accesses will be relative to its working directory. Type: String.
#
# [*soft_resource_limits*]
#   Soft Resource Limits - see launchd.info for more. Type: Hash.
#
# [*hard_resource_limits*]
#   Hard Resource Limits - see launchd.info for more. Type: Hash.
#
# [*run_at_load*]
#   Start launchd job as soon as it is loaded. Type: Boolean. Defaults to true.
#
# [*start_calendar_interval*]
#   Start launchd job at a certain date or time (see launchd.info). Type: Hash or Array of Hashes.
#
# [*start_interval*]
#   Start launchd job every n seconds. Type: Integer
# [*start_on_mount*]
#   Start launchd job whenever a device is mounted. Type: Boolean. Defaults to undef.
#
# [*watch_paths*]
#   If the path points to a file, creating, removing and writing to this file will be start the job.
#   If the path points to a directory, creating and removing this directory, as well as creating,
#   removing and writing files in this directory will start the job. Type: Array.
#
# [*queue_directories*]
#   Whenever one of the directories specified is not empty, the job will be started.
#   It is the responsibility of the job to remove each processed file,
#   otherwise the job will be restarted after throttle_interval seconds. Type: Array.
#
# [*keep_alive*]
#   launchd may be used to make sure that a job is running depending on certain conditions. See launchd.info for all options Type: Boolean or Hash.
#
# [*user_name*]
#   User the job should run as. Use full username, not id. Type: String.
#
# [*group_name*]
#   Group the job should run as. Use full group name, not gid. Type: String.
#
# [*init_groups*]
#   Specifies if launchd should call the function initgroups(3) before starting the job. Type: Boolean.
#
# [*umask*]
#   Using this key you can specify which permissions a file or folder will have by default when it is created by this job.
#   The value is expected to be a decimal number. Type: Integer.
#
# [*root_directory*]
#   Using this key you can execute the job in a chroot(2) jail. Type: String.
#
# [*abandon_process_group*]
#   UWhen launchd wants to terminate a job it sends a SIGTERM signal which will be propagated to all child processes of the job as well.
#   Setting the value of this key to true will stop this propagation, allowing the child processes to survive their parents. Type: Boolean.
#
# [*exit_timeout*]
#   launchd stops a job by sending the signal SIGTERM to the process.
#   Should the job not terminate within ExitTimeOut seconds (20 seconds by default), launchd will send signal SIGKILL to force-quit it. Type: Integer.
#
# [*timeout*]
#   The suggested idle time in seconds before the job should quit. Type: Integer.
#
# [*throttle_interval*]
#   Time in seconds to wait between program invocations. Type: Integer.
#
# [*legacy_timers*]
#   This key controls the behavior of timers created by the job. See launchd.info for more. Type: Boolean.
#
# [*nice*]
#   Run a job at an altered scheduling priority. Possible values range from -20 to 20.
#   The default value is 0. Lower nice values cause more favorable scheduling. Type: Integer.
#
# === Example
#
#  launchd::job { 'com.example.my_agent':
#    ensure      => 'present',
#    type        => 'deamon',
#    program     => '/usr/local/bin/my_binary'.
#    run_at_load => true,
#  }
#
define launchd::job (
    $ensure = 'present',
    $type = 'daemon',
    $source = undef,
    $content = undef,
    $disabled = false,
    $program = undef,
    $program_arguments = undef,
    $environment_variables = undef,
    $standard_in_path = undef,
    $standard_out_path = undef,
    $standard_error_path = undef,
    $working_directory = undef,
    $soft_resource_limits = undef,
    $hard_resource_limits = undef,
    $run_at_load = true,
    $start_calendar_interval = undef,
    $start_interval = undef,
    $start_on_mount = undef,
    $watch_paths = undef,
    $queue_directories = undef,
    $keep_alive = undef,
    $user_name = undef,
    $group_name = undef,
    $init_groups = undef,
    $umask = undef,
    $root_directory = undef,
    $abandon_process_group = undef,
    $exit_timeout = undef,
    $timeout = undef,
    $throttle_interval = undef,
    $legacy_timers = undef,
    $nice = undef
    ) {

    if $::kernel != 'Darwin' {
        fail('This module only works on OS X.')
    }

    # Validate the inputs
    if $ensure != 'present' and $ensure != 'absent' {
        fail('Ensure must be one of "present" or "absent"')
    }

    if $type != 'agent' and $type != 'daemon' {
        fail('Type must be one of "agent" or "daemon"')
    }

    if $content != undef {
        validate_string($content)
    }

    validate_bool($disabled)

    if $program != undef {
        validate_string($program)
    }

    if $program_arguments != undef {
        validate_array($program_arguments)
    }

    if $environment_variables != undef {
        validate_hash($environment_variables)
    }

    if $standard_in_path != undef {
        validate_absolute_path($standard_in_path)
    }

    if $standard_out_path != undef {
        validate_absolute_path($standard_out_path)
    }

    if $standard_error_path != undef {
        validate_absolute_path($standard_error_path)
    }

    if $working_directory != undef {
        validate_absolute_path($working_directory)
    }

    if $soft_resource_limits != undef {
        validate_hash($soft_resource_limits)
    }

    if $hard_resource_limits != undef {
        validate_hash($hard_resource_limits)
    }

    if $start_interval != undef {
        validate_integer($start_interval)
    }
    validate_bool($run_at_load)

    if $start_calendar_interval != undef {
        if is_hash($start_calendar_interval) == false and is_array($start_calendar_interval) == false {
            fail("start_calendar_interval must be an array or hash.")
        }

        if is_hash($start_calendar_interval) {
            $start_calendar_interval_type = 'dict'
        } elsif is_array($start_calendar_interval) {
            $start_calendar_interval_type = 'array'
        } else {
            fail("We should have a type by now.")
        }
    }

    if $start_on_mount != undef {
        validate_bool($start_on_mount)
    }

    if $watch_paths != undef {
        validate_array($watch_paths)
    }

    if $queue_directories != undef {
        validate_array($queue_directories)
    }

    if $keep_alive != undef {
        if is_hash($keep_alive) == false and is_bool($keep_alive) == false {
            fail("keep_alive must be a hash or bool.")
        }
        if is_hash($keep_alive) {
            $keep_alive_type = 'dict'
        } elsif is_bool($keep_alive) {
            $keep_alive_type = 'bool'
        }
    }

    if $user_name != undef {
        validate_string($user_name)
    }

    if $group_name != undef {
        validate_string($group_name)
    }

    if $init_groups != undef {
        validate_bool($init_groups)
    }

    if $umask != undef {
        validate_integer($umask)
    }

    if $root_directory != undef {
        validate_absolute_path($root_directory)
    }

    if $abandon_process_group != undef {
        validate_bool($abandon_process_group)
    }

    if $exit_timeout != undef {
        validate_integer($exit_timeout)
    }

    if $timeout != undef {
        validate_integer($timeout)
    }

    if $throttle_interval != undef {
        validate_integer($throttle_interval)
    }

    if $legacy_timers != undef {
        validate_bool($legacy_timers)
    }

    if $nice != undef {
        validate_integer($nice)
    }

    case $type {
        'agent': {
            $filepath = "/Library/LaunchAgents/${name}.plist"
        }
        'daemon': {
            $filepath = "/Library/LaunchDaemons/${name}.plist"
        }
        default: {
            fail("We shouldn't be here, $type should have been validated.")
        }
    }

    # if ensure present:
    if $ensure == 'present' {
        if $source == undef and $content == undef {
            # Write the launchd plist
            file {"${filepath}":
                ensure  => 'present',
                content => template('launchd/launchd_plist.erb'),
                mode    => '0644',
                owner   => '0',
                group   => '0',
                notify  => Exec["launchctl unload ${name}"]
            }
        }

        if $source != undef {
            file {"${filepath}":
                ensure => 'present',
                source => $source,
                mode   => '0644',
                owner  => '0',
                group  => '0',
                notify => Exec["launchctl unload ${name}"]
            }
        }

        if $content != undef {
            file {"${filepath}":
                ensure  => 'present',
                content => $content,
                mode    => '0644',
                owner   => '0',
                group   => '0',
                notify  => Exec["launchctl unload ${name}"]
            }
        }

        if $type == 'agent' {
            # If it's a launchagent, check if there's a user logged in
            if $::launchd_current_user != '' and $::launchd_current_user != 'root' and $::launchd_current_user != 'None'{
                # If there is, load it as the user
                exec { "launchctl unload ${name}":
                    command     => "launchctl unload ${filepath}",
                    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
                    user        => $::launchd_current_user,
                    onlyif      => "launchctl list | grep -qw \"${name}\"",
                    refreshonly => true,
                    before      => Exec["launchctl load ${name}"]
                }
                exec { "launchctl load ${name}":
                    command     => "launchctl load ${filepath}",
                    path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
                    user        => $::launchd_current_user,
                    unless      => "launchctl list | grep -qw \"${name}\"",
                    require     => File["${filepath}"]
                }
            }
        }

        if $type == 'daemon' {
            exec { "launchctl unload ${name}":
                command     => "launchctl unload ${filepath}",
                path        => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
                onlyif      => "launchctl list | grep -qw \"${name}\"",
                refreshonly => true,
                before      => Exec["launchctl load ${name}"]
            }
            exec { "launchctl load ${name}":
                command => "launchctl load ${filepath}",
                path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
                unless  => "launchctl list | grep -qw \"${name}\"",
                require => File["${filepath}"]
            }
        }
    }

    if $ensure == 'absent' {
        # Unload if loaded
        exec { "launchctl unload ${name}":
            command => "launchctl unload ${filepath}",
            path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
            onlyif  => "launchctl list | grep -qw \"${name}\"",
            before  => File["${filepath}"]
        }

        # Remove file
        file {"${filepath}":
            ensure => 'absent',
        }
    }
}
