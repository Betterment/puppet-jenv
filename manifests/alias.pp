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
  notice("Alias from ${version} to ${to}")

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
  notice("link_ensure: ${link_ensure}")

  $sys_version = java_download_version_to_sys_version($to)
  $jdk_dir = "/Library/Java/JavaVirtualMachines/jdk${version}.jdk"

  file { [$jdk_dir]:
    ensure  => $dir_ensure,
    force   => true
  } 
}
