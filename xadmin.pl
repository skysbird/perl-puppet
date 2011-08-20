#!/usr/bin/perl
use strict;
use Getopt::Long;

our $puppet_conf_path = "/etc/puppet/manifests/temp/";
our $cache_conf_path ="/var/lib/puppet/yaml/node/";

my ($adduser,$username,$shell,$hostlist,$groups,$deluser,$m,$moduser,$membership,$email);
my ($addgroup,$groupname,$delgroup);
GetOptions(
        'adduser!' => \$adduser,
        'host=s' => \$hostlist,
        'username=s' => \$username,
        'shell=s' => \$shell,
    	'groups=s'=>\$groups,
        'email=s'=>\$email,

        'deluser!'=>\$deluser,
        'm!'=>\$m,

        'moduser!'=>\$moduser,
        'membership=s'=>\$membership,

        'addgroup!'=>\$addgroup,
        'groupname=s'=>\$groupname,

        'delgroup!'=>\$delgroup,

);
use String::MkPasswd qw(mkpasswd);

if ($adduser==1){
	my @hostarray = split(/,/,$hostlist);
	my $host;
    my $title;
    my $password = mkpasswd(-length=>13,-minnum=>4,-minspecial=>3);
	
    foreach $host(@hostarray){
		&do_adduser($username,$shell,$host,$groups,$password);
	}

    #mail notify the user about account information
    use Template;

    my $tt = Template->new({
        INCLUDE_PATH => 'mail/',
    }) || die "$Template::ERROR\n";

    my $vars = {
        username     => $username,
        password    => $password,
        hostlist => $hostlist,
    };
    
    my $output;
    $tt->process('account.tt', $vars,\$output);
    $title = "Account_Created";
    &do_mail($email,$title,$output);
}



if ($deluser==1){
	my @hostarray = split(/,/,$hostlist);
	my $host;
	foreach $host(@hostarray){
        if ($m==1){
            &do_del_user_with_home($username,$host);
        }
        else{
            &do_del_user($username,$host);
        }
    }
}


if ($moduser==1){
	my @hostarray = split(/,/,$hostlist);
	my $host;
	foreach $host(@hostarray){
         &do_mod_user($username,$groups,$membership,$host);
    }
}

if ($addgroup==1){
	my @hostarray = split(/,/,$hostlist);
	my $host;
	foreach $host(@hostarray){
         &do_add_group($groupname,$host);
    }
}

if ($delgroup==1){
	my @hostarray = split(/,/,$hostlist);
	my $host;
	foreach $host(@hostarray){
         &do_del_group($groupname,$host);
    }

}


sub do_mail(){
    my($email,$title,$content)=@_;
    $content =~ s/\n//ig;
    `echo '$content'|mail $email -s '$title' -b test\@i-waihui.com -a 'MIME-Version: 1.0' -a 'Content-Type: text/html; charset=iso-8859-1'` ;
}

sub do_del_group(){
    my($groupname,$hostn)=@_;
   	open(FILE,">$hostn.pp") or &out_err("wrong to create file");
	print FILE 
	"
	node '$hostn'{
		group{'$groupname':
            ensure=>absent            
		}
	}
	\n";
	close(FILE);
	`mv $hostn.pp $puppet_conf_path`; 		
	#call puppet run to push the command
#	`service puppetmaster restart`;
	`puppetrun --host $hostn --ignorecache`;
	#`rm $puppet_conf_path$hostn.pp`; 		

}

sub do_add_group(){
    my($groupname,$hostn)=@_;
   	open(FILE,">$hostn.pp") or &out_err("wrong to create file");
	print FILE 
	"
	node '$hostn'{
		group{'$groupname':
            ensure=>present            
		}
	}
	\n";
	close(FILE);
	`mv $hostn.pp $puppet_conf_path`; 		
	#call puppet run to push the command
#	`service puppetmaster restart`;
	`puppetrun --host $hostn --ignorecache`;
	#`rm $puppet_conf_path$hostn.pp`; 		

}


sub do_adduser(){
	my($username,$shell,$hostn,$groups,$password)=@_;
	open(FILE,">$hostn.pp") or &out_err("wrong to create file");
	print FILE 
	"
	node '$hostn'{
		include users
		include default_groups
		add_user{'$username':
			username =>'$username',
			groups =>'$groups',
			password =>'$password',
			email=>'test\@i-waihui.com',
			require=>Class['default_groups'],
		}
	}
	\n";
	close(FILE);
	`mv $hostn.pp $puppet_conf_path`; 		
    `touch $puppet_conf_path$hostn.pp`;
	#call puppet run to push the command
#	`service puppetmaster restart`;
	`puppetrun --host $hostn --ignorecache`;
	#`rm $puppet_conf_path$hostn.pp`; 		

}

sub do_del_user_inner(){
	my($username,$hostn,$m)=@_;
	open(FILE,">$hostn.pp") or &out_err("wrong to create file");
    my $method="";
    if ($m==0){
        $method = "del_user";
    }
    else{
        $method = "del_user_with_home";
    }

	print FILE 
	"
	node '$hostn'{
		include users
		${method}{'$username':
			username =>'$username'
		}
	}
	\n";
	close(FILE);
	`mv $hostn.pp $puppet_conf_path`; 		
    `touch $puppet_conf_path$hostn.pp`;
	`puppetrun --host $hostn --ignorecache`;
	#`rm $puppet_conf_path$hostn.pp`; 		

}

sub do_del_user(){
    my($username,$hostn)=@_;
    &do_del_user_inner($username,$hostn,0);
}

sub do_del_user_with_home(){
    my($username,$hostn)=@_;
    &do_del_user_inner($username,$hostn,1);
}

sub do_mod_user(){
	my($username,$groups,$membership,$hostn)=@_;
	open(FILE,">$hostn.pp") or &out_err("wrong to create file");
	print FILE 
	"
	node '$hostn'{
		include users
		mod_user{'$username':
			username =>'$username',
			groups =>[$groups],
            membership=>'$membership'
		}
	}
	\n";
	close(FILE);
	`mv $hostn.pp $puppet_conf_path`; 		
    `touch $puppet_conf_path$hostn.pp`;
	#call puppet run to push the command
#	`service puppetmaster restart`;
	`puppetrun --host $hostn --ignorecache`;
	#`rm $puppet_conf_path$hostn.pp`; 		

}

