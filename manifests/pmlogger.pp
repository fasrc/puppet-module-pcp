# Define: pcp::pmlogger: See README.md for documentation
define pcp::pmlogger (
  $ensure         = 'present',
  $hostname       = 'LOCALHOSTNAME',
  $primary        = false,
  $socks          = false,
  $log_dir        = 'PCP_LOG_DIR/pmlogger/LOCALHOSTNAME',
  $args           = '',
  $config_path    = undef,
  $pmcd_connect_timeout = '20',
  $pmcd_connect_timeout = '15',
  $control_hostername = undef,
  $control_primary = undef,
  $control_socks = undef,
  $control_log_dir = undef,
  $control_args = undef
) {

  include pcp

  Class['pcp::install'] -> Pcp::Pmlogger[$title]

  validate_bool(
    $primary,
    $socks
  )

  if $primary {
    $_primary = 'y'
  } else {
    $_primary = 'n'
  }

  if $socks {
    $_socks = 'y'
  } else {
    $_socks = 'n'
  }

  if $config_path {
    $_args = "${args} -c ${config_path}"
  } else {
    $_args = $args
  }

  $_pmlogger_config_path = "/etc/pcp/pmlogger/control.d/${name}"
  $_line = "#This file is managed by Puppet\n${hostname} ${_primary} ${_socks} ${log_dir} ${_args}\n"

  file { "pmlogger-${name}":
    ensure  => $ensure,
    path    => $_pmlogger_config_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $_line,
    notify  => Service['pmlogger'],
  }

  if $config_path {
    file { "pmlogger-${name}-config":
      ensure  => $ensure,
      path    => $config_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('pcp/pmlogger-${name}.config.erb'),
      notify  => Service['pmlogger'],
      before  => File["pmlogger-${name}"],
    }
  }

  file { '/etc/pcp/pmlogger/control':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('pcp/control.erb'),
    notify  => Service['pmlogger'],
  }

}
