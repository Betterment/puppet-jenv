# Java Puppet Module for Boxen ![](https://travis-ci.org/Betterment/puppet-jenv.svg)

Install Java versions using [jenv](https://github.com/yyuu/jenv). Module based off of [puppet-ruby](https://github.com/boxen/puppet-ruby) and [puppet-python](https://github.com/mloberg/puppet-python).

## Usage

Supported versions can be found [here](https://github.com/Betterment/puppet-jenv/blob/master/data/common.yaml).

```puppet
# Install Java versions

java::version { '1.7.0_71': }
java::version { '1.8.0_31': }

# Set the global version of Java
class { 'java::global':
  version => '1.7.0_71'
}

# ensure a certain java version is used in a dir
java::local { '/path/to/some/project':
  version => '1.8.0_31'
}

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.
