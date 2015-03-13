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
  $applet_dir = "/Library/Internet Plug-Ins/JavaAppletPlugin.Plug-Ins"
  $prefpane_link = "/Library/PreferencePanes/JavaControlPanel.prefPane"
  $jenv_versions = "${java::jenv::prefix}/versions"

  # file { [$prefpane_link]:
  #   ensure  => $link_ensure,
  #   target  => "${applet_dir}/Contents/Home/lib/deploy/JavaControlPanel.prefPane",
  #   force   => true,
  #   require => Java::Version[$to]
  # } 

  file { [$jdk_dir]:
    ensure  => $dir_ensure,
    force   => true
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