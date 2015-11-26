class n98magerun (
  $version = '1.97.7'
) {

  #todo: Make this module depend on puppet-php
  $installdir = "${php::config::root}/bin"

  file { [$installdir ]:
    ensure  => 'directory',
    owner   => $::boxen_user,
    group   => 'staff',
    mode    => '0755',
    require => undef,
    before  => Exec["install magerun to ${installdir}"],
  }

  #todo: is it possible to make this thing depend on both curl, tar, chmod, mv, rm, rmdir?
  #todo: or do we just kind of expect these things to be available on a real system?
  exec { "install magerun to ${installdir}":
    command => "curl -o magerun.tar.gz https://codeload.github.com/netz98/n98-magerun/tar.gz/$version &&
                tar -zxf magerun.tar.gz n98-magerun-$version/n98-magerun.phar &&
                mv n98-magerun-$version/n98-magerun.phar ./magerun &&
                chmod +X magerun &&
                rm magerun.tar.gz &&
                rmdir n98-magerun-$version",
    cwd     => $installdir,
    user    => $::boxen_user,
    creates => ["$installdir/magerun"],
    require => File[$installdir],
  }

  File {
    require => Exec["install magerun to ${installdir}"],
  }

  #todo: what is an anchor?
  anchor { 'Hello_World': }
}
