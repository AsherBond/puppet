---
layout: default
built_from_commit: a0909f4eae7490d52cb1e7dc81010592ba607679
title: 'Man Page: puppet agent'
canonical: "/puppet/latest/man/agent.html"
---

# Man Page: puppet agent

> **NOTE:** This page was generated from the Puppet source code on 2024-11-04 23:37:39 +0000

## NAME
**puppet-agent** - The puppet agent daemon

## SYNOPSIS
Retrieves the client configuration from the Puppet master and applies it
to the local host.

This service may be run as a daemon, run periodically using cron (or
something similar), or run interactively for testing purposes.

## USAGE
puppet agent \[\--certname *NAME*\]
\[-D\|\--daemonize\|\--no-daemonize\] \[-d\|\--debug\]
\[\--detailed-exitcodes\] \[\--digest *DIGEST*\] \[\--disable
\[MESSAGE\]\] \[\--enable\] \[\--fingerprint\] \[-h\|\--help\]
\[-l\|\--logdest syslog\|eventlog\|*ABS FILEPATH*\|console\]
\[\--serverport *PORT*\] \[\--noop\] \[-o\|\--onetime\]
\[\--sourceaddress *IP_ADDRESS*\] \[-t\|\--test\] \[-v\|\--verbose\]
\[-V\|\--version\] \[-w\|\--waitforcert *SECONDS*\]

## DESCRIPTION
This is the main puppet client. Its job is to retrieve the local
machine\'s configuration from a remote server and apply it. In order to
successfully communicate with the remote server, the client must have a
certificate signed by a certificate authority that the server trusts;
the recommended method for this, at the moment, is to run a certificate
authority as part of the puppet server (which is the default). The
client will connect and request a signed certificate, and will continue
connecting until it receives one.

Once the client has a signed certificate, it will retrieve its
configuration and apply it.

## USAGE NOTES
\'puppet agent\' does its best to find a compromise between interactive
use and daemon use. If you run it with no arguments and no
configuration, it goes into the background, attempts to get a signed
certificate, and retrieves and applies its configuration every 30
minutes.

Some flags are meant specifically for interactive use \-\-- in
particular, \'test\', \'tags\' and \'fingerprint\' are useful.

\'\--test\' runs once in the foreground with verbose logging, then
exits. It also exits if it can\'t get a valid catalog. **\--test**
includes the \'\--detailed-exitcodes\' option by default and exits with
one of the following exit codes:

-   0: The run succeeded with no changes or failures; the system was
    already in the desired state.

-   1: The run failed, or wasn\'t attempted due to another run already
    in progress.

-   2: The run succeeded, and some resources were changed.

-   4: The run succeeded, and some resources failed.

-   6: The run succeeded, and included both changes and failures.

\'\--tags\' allows you to specify what portions of a configuration you
want to apply. Puppet elements are tagged with all of the class or
definition names that contain them, and you can use the \'tags\' flag to
specify one of these names, causing only configuration elements
contained within that class or definition to be applied. This is very
useful when you are testing new configurations \-\-- for instance, if
you are just starting to manage \'ntpd\', you would put all of the new
elements into an \'ntpd\' class, and call puppet with \'\--tags ntpd\',
which would only apply that small portion of the configuration during
your testing, rather than applying the whole thing.

\'\--fingerprint\' is a one-time flag. In this mode \'puppet agent\'
runs once and displays on the console (and in the log) the current
certificate (or certificate request) fingerprint. Providing the
\'\--digest\' option allows you to use a different digest algorithm to
generate the fingerprint. The main use is to verify that before signing
a certificate request on the master, the certificate request the master
received is the same as the one the client sent (to prevent against
man-in-the-middle attacks when signing certificates).

\'\--skip_tags\' is a flag used to filter resources. If this is set,
then only resources not tagged with the specified tags will be applied.
Values must be comma-separated.

## OPTIONS
Note that any Puppet setting that\'s valid in the configuration file is
also a valid long argument. For example, \'server\' is a valid setting,
so you can specify \'\--server *servername*\' as an argument. Boolean
settings accept a \'\--no-\' prefix to turn off a behavior, translating
into \'\--setting\' and \'\--no-setting\' pairs, such as
**\--daemonize** and **\--no-daemonize**.

See the configuration file documentation at
https://puppet.com/docs/puppet/latest/configuration.html for the full
list of acceptable settings. A commented list of all settings can also
be generated by running puppet agent with \'\--genconfig\'.

-   \--certname: Set the certname (unique ID) of the client. The master
    reads this unique identifying string, which is usually set to the
    node\'s fully-qualified domain name, to determine which
    configurations the node will receive. Use this option to debug setup
    problems or implement unusual node identification schemes. (This is
    a Puppet setting, and can go in puppet.conf.)

-   \--daemonize: Send the process into the background. This is the
    default. (This is a Puppet setting, and can go in puppet.conf. Note
    the special \'no-\' prefix for boolean settings on the command
    line.)

-   \--no-daemonize: Do not send the process into the background. (This
    is a Puppet setting, and can go in puppet.conf. Note the special
    \'no-\' prefix for boolean settings on the command line.)

-   \--debug: Enable full debugging.

-   \--detailed-exitcodes: Provide extra information about the run via
    exit codes; works only if \'\--test\' or \'\--onetime\' is also
    specified. If enabled, \'puppet agent\' uses the following exit
    codes:

    0: The run succeeded with no changes or failures; the system was
    already in the desired state.

    1: The run failed, or wasn\'t attempted due to another run already
    in progress.

    2: The run succeeded, and some resources were changed.

    4: The run succeeded, and some resources failed.

    6: The run succeeded, and included both changes and failures.

-   \--digest: Change the certificate fingerprinting digest algorithm.
    The default is SHA256. Valid values depends on the version of
    OpenSSL installed, but will likely contain MD5, MD2, SHA1 and
    SHA256.

-   \--disable: Disable working on the local system. This puts a lock
    file in place, causing \'puppet agent\' not to work on the system
    until the lock file is removed. This is useful if you are testing a
    configuration and do not want the central configuration to override
    the local state until everything is tested and committed.

    Disable can also take an optional message that will be reported by
    the \'puppet agent\' at the next disabled run.

    \'puppet agent\' uses the same lock file while it is running, so no
    more than one \'puppet agent\' process is working at a time.

    \'puppet agent\' exits after executing this.

-   \--enable: Enable working on the local system. This removes any lock
    file, causing \'puppet agent\' to start managing the local system
    again However, it continues to use its normal scheduling, so it
    might not start for another half hour.

    \'puppet agent\' exits after executing this.

-   \--evaltrace: Logs each resource as it is being evaluated. This
    allows you to interactively see exactly what is being done. (This is
    a Puppet setting, and can go in puppet.conf. Note the special
    \'no-\' prefix for boolean settings on the command line.)

-   \--fingerprint: Display the current certificate or certificate
    signing request fingerprint and then exit. Use the \'\--digest\'
    option to change the digest algorithm used.

-   \--help: Print this help message

-   \--job-id: Attach the specified job id to the catalog request and
    the report used for this agent run. This option only works when
    \'\--onetime\' is used. When using Puppet Enterprise this flag
    should not be used as the orchestrator sets the job-id for you and
    it must be unique.

-   \--logdest: Where to send log messages. Choose between \'syslog\'
    (the POSIX syslog service), \'eventlog\' (the Windows Event Log),
    \'console\', or the path to a log file. If debugging or verbosity is
    enabled, this defaults to \'console\'. Otherwise, it defaults to
    \'syslog\' on POSIX systems and \'eventlog\' on Windows. Multiple
    destinations can be set using a comma separated list (eg:
    **/path/file1,console,/path/file2**)\"

    A path ending with \'.json\' will receive structured output in JSON
    format. The log file will not have an ending \'\]\' automatically
    written to it due to the appending nature of logging. It must be
    appended manually to make the content valid JSON.

    A path ending with \'.jsonl\' will receive structured output in JSON
    Lines format.

-   \--masterport: The port on which to contact the Puppet Server. (This
    is a Puppet setting, and can go in puppet.conf. Deprecated in favor
    of the \'serverport\' setting.)

-   \--noop: Use \'noop\' mode where the daemon runs in a no-op or
    dry-run mode. This is useful for seeing what changes Puppet would
    make without actually executing the changes. (This is a Puppet
    setting, and can go in puppet.conf. Note the special \'no-\' prefix
    for boolean settings on the command line.)

-   \--onetime: Run the configuration once. Runs a single (normally
    daemonized) Puppet run. Useful for interactively running puppet
    agent when used in conjunction with the \--no-daemonize option.
    (This is a Puppet setting, and can go in puppet.conf. Note the
    special \'no-\' prefix for boolean settings on the command line.)

-   \--serverport: The port on which to contact the Puppet Server. (This
    is a Puppet setting, and can go in puppet.conf.)

-   \--sourceaddress: Set the source IP address for transactions. This
    defaults to automatically selected. (This is a Puppet setting, and
    can go in puppet.conf.)

-   \--test: Enable the most common options used for testing. These are
    \'onetime\', \'verbose\', \'no-daemonize\',
    \'no-usecacheonfailure\', \'detailed-exitcodes\', \'no-splay\', and
    \'show_diff\'.

-   \--trace Prints stack traces on some errors. (This is a Puppet
    setting, and can go in puppet.conf. Note the special \'no-\' prefix
    for boolean settings on the command line.)

-   \--verbose: Turn on verbose reporting.

-   \--version: Print the puppet version number and exit.

-   \--waitforcert: This option only matters for daemons that do not yet
    have certificates and it is enabled by default, with a value of 120
    (seconds). This causes \'puppet agent\' to connect to the server
    every 2 minutes and ask it to sign a certificate request. This is
    useful for the initial setup of a puppet client. You can turn off
    waiting for certificates by specifying a time of 0. (This is a
    Puppet setting, and can go in puppet.conf.)

-   \--write_catalog_summary After compiling the catalog saves the
    resource list and classes list to the node in the state directory
    named classes.txt and resources.txt (This is a Puppet setting, and
    can go in puppet.conf.)

## EXAMPLE

    $ puppet agent --server puppet.domain.com

## DIAGNOSTICS
Puppet agent accepts the following signals:

SIGHUP

:   Restart the puppet agent daemon.

SIGINT and SIGTERM

:   Shut down the puppet agent daemon.

SIGUSR1

:   Immediately retrieve and apply configurations from the puppet
    master.

SIGUSR2

:   Close file descriptors for log files and reopen them. Used with
    logrotate.

## AUTHOR
Luke Kanies

## COPYRIGHT
Copyright (c) 2011 Puppet Inc., LLC Licensed under the Apache 2.0
License