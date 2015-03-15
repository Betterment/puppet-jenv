# Aliases a java version to another
#
# Usage:
#     java::alias { '2.7': to => '2.7.8' }
#
define java::alias (
  $ensure  = 'installed',
  $to      = undef,
  $version = $title,
) {
  require java

  if $to == undef {
    fail('to cannot be undefined')
  }

  if $ensure != 'absent' {
    ensure_resource('java::version', $to)
  }

  $dir_ensure = $ensure ? {
    /^(installed|present)$/ => 'directory',
    default                 => $ensure,
  }
  $link_ensure = $ensure ? {
    /^(installed|present)$/ => 'link',
    default                 => $ensure,
  }

  $sys_version = java_download_version_to_sys_version($to)
  $jdk_dir = "/Library/Java/JavaVirtualMachines/jdk${version}.jdk"
  $jenv_versions = "${java::jenv::prefix}/versions"
  $sec_dir = "${jdk_dir}/Contents/Home/jre/lib/security"

  file { [$jdk_dir]:
    ensure  => $dir_ensure,
    force   => true
  } 

  # Allow 'large' keys locally.
  # http://www.ngs.ac.uk/tools/jcepolicyfiles
  file { $sec_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'wheel',
    mode    => '0775',
    require => File[$jdk_dir]
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

  # add the version to jenv - use jenv's add in the future?
  file { "${jenv_versions}/${version}":
    ensure  => $link_ensure,
    target  => "${jdk_dir}/Contents/Home",
    force   => true,
    require => File["${jenv_versions}"]
  }
}

# }