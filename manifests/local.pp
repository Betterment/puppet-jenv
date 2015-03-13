# Make sure a specific version of Java is used in a directory
#
# Usage:
#
#   java::local { '/path/to/directory': version => '3.3.0' }
#

define java::local(
  $version = undef,
  $ensure  = present,
) {
  include java

  $alias_hash = hiera_hash('java::version::alias', {})

  if has_key($alias_hash, $version) {
    $require_version = $alias_hash[$version]
  } else {
    $require_version = $version
  }


  case $version {
    'system', undef: { $require = undef }

    default: {
      ensure_resource('java::version', $version)
      $require = Java::Version[$require_version]
    }

  }

  file { "${name}/.java-version":
    ensure  => $ensure,
    owner   => $java::user,
    content => "${version}\n",
    replace => true,
    require => $require
  }
}