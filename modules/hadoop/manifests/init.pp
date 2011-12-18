class hadoop {
	
	$hadoop_version = '0.20'
	$hadoop_name = "hadoop-${hadoop_version}"
	
	apt::sources_list { "cdh3":
		ensure => present,
		content => "deb http://archive.cloudera.com/debian lucid-cdh3 contrib",		
	}

	apt::key {'02A818DD':
		source => 'http://archive.cloudera.com/debian/archive.key',
		require => Apt::Sources_list['cdh3']
	}
	
	package { "hadoop":
	  name => "${hadoop_name}",
		ensure => present,
		require => Apt::Sources_list['cdh3']	
	}
	
	package {'hadoop-conf':
		name => "${hadoop_name}-conf-pseudo",
		ensure => present
	}	
	
	file { 'mapred-site.xml':
		path => '/etc/hadoop/conf/mapred-site.xml',
		ensure => file,
		require => Package['hadoop-conf'], # maybe just hadoop...
		source => 'puppet:///modules/hadoop/mapred-site.xml'
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
			subscribe => File['mapred-site.xml']
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