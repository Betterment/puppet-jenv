# Specify the global Java version
#
# Usage:
#
#   class { 'java::global': version => '2.7.3' }
#

class java::global(
  $version = '1.7.0_71',
) {
  require java

  $alias_hash = hiera_hash('java::version::alias', {})

  if has_key($alias_hash, $version) {
    $require_version = $alias_hash[$version]
  } else {
    $require_version = $version
  }

  if $version != 'system' {
    $require = Java::Version[$require_version]
  } else {
    $require = undef
  }

  file { "${java::jenv::prefix}/version":
    ensure  => present,
    owner   => $java::user,
    mode    => '0644',
    content => "${version}\n",
    require => $require,
  }
}