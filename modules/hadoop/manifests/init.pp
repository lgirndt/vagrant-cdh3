class hadoop {
	
	$hadoop_version = '0.20'
	$hadoop_name = "hadoop-${hadoop_version}"
	
	apt::key {'02A818DD':
		source => 'http://archive.cloudera.com/debian/archive.key',		
	}	
	
	apt::sources_list { "cdh3":
		ensure => present,
		content => "deb http://archive.cloudera.com/debian lucid-cdh3 contrib",		
		require => Apt::Key['02A818DD'],
	}
	
	package { "hadoop":
	  name => "${hadoop_name}",
		ensure => present,
		require => Class['java']
	}
	
	package {'hadoop-conf':
		name => "${hadoop_name}-conf-pseudo",
		ensure => present,
		require => Package['hadoop']
	}	
	
	file { 'mapred-site.xml':
		path => '/etc/hadoop/conf/mapred-site.xml',
		ensure => file,
		require => Package['hadoop-conf'], # maybe just hadoop...
		source => 'puppet:///modules/hadoop/mapred-site.xml'
	}
	
	file { 'core-site.xml':
		path => '/etc/hadoop/conf/core-site.xml',
		ensure => file,
		require => Package['hadoop-conf'], # maybe just hadoop...
		source => 'puppet:///modules/hadoop/core-site.xml'		
	}
	
	define daemon(
		$daemon = $title
	){
		
		$hadoop_name = $hadoop::hadoop_name
		
		package { "hadoop-${daemon}":
			name   => "${hadoop_name}-${daemon}",
			ensure => present,
			require => Package['hadoop']
		}

		service { "hadoop-${daemon}":
			name   => "${hadoop_name}-${daemon}",
			ensure => running,
			enable => true,
			subscribe => File['mapred-site.xml','core-site.xml']
		}
	} 
	
	class pig {
		
		package {"hadoop-pig":
			ensure => present,
			require => Package['hadoop']
		}
		
	}
	
	daemon { 'namenode':}	
	daemon { 'datanode':}	
	daemon { 'secondarynamenode':}
	daemon { 'jobtracker':}
	daemon { 'tasktracker':}	
	
	class {'pig':}
}