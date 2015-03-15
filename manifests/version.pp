# Install a Java version via jenv
#
# Usage:
#
#   java::version { '1.7': }
#

define java::version(
  $ensure  = 'installed',
  $env     = {},
  $version = $name,
  $base_download_url = 'https://s3.amazonaws.com/better-boxen/java',
) {
  require java

  $alias_hash = hiera_hash('java::version::alias', {})

  if has_key($alias_hash, $version) {
    $to = $alias_hash[$version]

    java::alias { $version:
      ensure => $ensure,
      to     => $to,
    }
  } elsif $ensure == 'absent' {
    # TODO: remove the installed version
  } else {

    include boxen::config

    $jre_url = "${base_download_url}/jre-${version}-macosx-x64.dmg"
    $jdk_url = "${base_download_url}/jdk-${version}-macosx-x64.dmg"
    # if ((versioncmp($::macosx_productversion_major, '10.10') >= 0) and
    #   versioncmp($update_version, '71') < 0)
    # {
    #   fail('Yosemite Requires Java 7 with a patch level >= 71 (Bug JDK-8027686)')
    # }

    package {
      "jre-${version}.dmg":
        ensure   => present,
        alias    => "java-jre-${version}",
        provider => pkgdmg,
        source   => $jre_url ;
      "jdk-${version}.dmg":
        ensure   => present,
        alias    => "java-${version}",
        provider => pkgdmg,
        source   => $jdk_url ;
    }
  }
}
