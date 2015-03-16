# Install jenv so Java versions can be installed
#
# Usage:
#
#   include java
#
class java(
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

    # setup smart JAVA_HOME plugin
    exec { 'jenv export plugin':
      command => 'jenv enable-plugin export',
      user => $user,
      require => Class['java::jenv']
    }
  }

  Class['java::jenv'] ->
    Java::Version <| |>
}
