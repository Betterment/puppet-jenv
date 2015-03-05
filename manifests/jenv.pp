# Manage java versions with jenv.
#
# Usage:
#
#     include java::jenv
#
# Normally internal use only; will be automatically included by the `java` class

class java::jenv(
  $ensure = $java::jenv::ensure,
  $prefix = $java::jenv::prefix,
  $user   = $java::jenv::user,
) {

  require java

  repository { $prefix:
    ensure => $ensure,
    force  => true,
    source => 'gcuisinier/jenv',
    user   => $user
  }

  file { "${prefix}/versions":
    ensure  => symlink,
    force   => true,
    backup  => false,
    target  => '/opt/javas',
    require => Repository[$prefix],
  }

}
