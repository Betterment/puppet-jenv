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
  notice("The version is ${version}")

  $alias_hash = hiera_hash('java::version::alias', {})

  if has_key($alias_hash, $version) {
    notice("Has key")
    $to = $alias_hash[$version]

    java::alias { $version:
      ensure => $ensure,
      to     => $to,
    }
  } elsif $ensure == 'absent' {
    # TODO: remove the installed version
  } else {

    include boxen::config

    $sys_version = java_download_version_to_sys_version($version)
    $jre_url = "${base_download_url}/jre-${version}-macosx-x64.dmg"
    $jdk_url = "${base_download_url}/jdk-${version}-macosx-x64.dmg"
    $jenv_versions = "${java::jenv::prefix}/versions"
    $jdk_dir = "/Library/Java/JavaVirtualMachines/jdk${sys_version}.jdk"
    $sec_dir = "${jdk_dir}/Contents/Home/jre/lib/security"

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

    file { $sec_dir:
      ensure  => 'directory',
      owner   => 'root',
      group   => 'wheel',
      mode    => '0775',
      require => Package["java-${version}"]
    }

    file { "${sec_dir}/local_policy.jar":
      source  => 'puppet:///modules/java/local_policy.jar',
      owner   => 'root',
      group   => 'wheel',
      mode    => '0664',
      require => File[$sec_dir]
    }

    file { "${sec_dir}/US_export_policy.jar":
      source  => 'puppet:///modules/java/US_export_policy.jar',
      owner   => 'root',
      group   => 'wheel',
      mode    => '0664',
      require => File[$sec_dir]
    }

    notice("installing to ${jenv_versions}/${sys_version}")

    # add the version to jenv - use jenv's add in the future?
    file { "${jenv_versions}/${sys_version}":
      ensure  => $link_ensure,
      target  => "${jdk_dir}/Contents/Home",
      force   => true,
      require => File["${jenv_versions}"]
    }
  }
}
