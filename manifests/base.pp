include apt

Exec { path => "/bin:/sbin:/usr/bin:/usr/sbin" }

group { "puppet":
  ensure => "present"
}

apt::sources_list { "partner":
	ensure => present,
	content => "deb http://archive.canonical.com/ubuntu ${lsbdistcodename} partner"
}

class {'java':
	require => Exec["apt-get_update"]
}

class {'hadoop':
}