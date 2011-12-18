Exec { path => "/bin:/sbin:/usr/bin:/usr/sbin" }
include apt

group { "puppet":
  ensure => "present"
}

apt::sources_list { "partner":
	ensure => present,
	content => "deb http://archive.canonical.com/ubuntu ${lsbdistcodename} partner"
}

class {'java':
	require => Apt::Sources_list['partner']
}

class {'hadoop':}