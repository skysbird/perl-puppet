class sudo
{
	$filepath = $operatingsystem?{
		freebsd =>"/usr/local/etc/sudoers",
		ubuntu =>"/etc/sudoers"
	}
	$source = $operatingsystem?{
		freebsd =>"puppet://puppet.local.xinwaihui.com/files/sudoer/freebsd/sudoers",
		ubuntu =>"puppet://puppet.local.xinwaihui.com/files/sudoer/linux/sudoers",
	}

	$group = $operatingsystem?{
		freebsd =>"wheel",
		ubuntu =>"root"
	}

	file{
		$filepath:
	 	owner=>"root",
		group=>$group,
		mode=>440,
		source =>$source
	}
}
