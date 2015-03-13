module Puppet::Parser::Functions
  newfunction(:java_download_version_to_sys_version, :type => :rvalue) do |args|
    unless args.length == 1
      raise Puppet::Error, "Must provide exactly one arg to java_download_version_to_sys_version"
    end

    major_version = args[0].split('u')[0]
    minor_version = args[0].split('u')[1]

    "1.#{major_version}.0_#{minor_version}"
  end
end
