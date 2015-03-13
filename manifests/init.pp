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

  include java::jenv

  if $::osfamily == 'Darwin' {
    include boxen::config

    boxen::env_script { 'jenv':
      content  => template('java/jenv.sh.erb'),
      priority => 'higher'
    }

    $wrapper = "${boxen::config::bindir}/java"
    
    file { $wrapper:
        source  => 'puppet:///modules/java/java.sh',
        mode    => '0755',
    }
  }




  Class['java::jenv'] ->
    Java::Version <| |>
}
