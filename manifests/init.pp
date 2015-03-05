# Install jenv so Java versions can be installed
#
# Usage:
#
#   include java
#
class java(
  $prefix   = $java::prefix,
  $user     = $java::user,
) {
  if $::osfamily == 'Darwin' {
    include boxen::config
  }

  include java::pyenv

  if $::osfamily == 'Darwin' {
    boxen::env_script { 'pyenv':
      content  => template('java/pyenv.sh.erb'),
      priority => 'higher'
    }
  }

  file { '/opt/java':
    ensure => directory,
    owner  => $user,
  }

  Class['java::jenv'] ->
    Python::Version <| |> ->
    Python::Plugin <| |>
}}
