define add_user ($username, $usershell='/bin/bash', $groups,$password,$email)
{
#       $uexist= regsubst($etcpasswd,".*^($username)(:).*$",'\1','M')
#       if $uexist!=$username
#       { 
       $os = $operatingsystem
       if ($os=='freebsd'){
           user
           {   "add_$username":
               name=>$username,
               shell => $usershell,
               groups => $groups,
               home  => "/home/$username",
               managehome=>true,
           before => Exec["changepass_$username"],
           }


           exec{ "changepass_$username":
            path              => "/bin:/sbin:/usr/bin:/usr/sbin",
            command     => "echo '$password'|pw usermod $username -h 0",
            subscribe =>User["$username"],
            refreshonly =>true;
          }
        }
    
#    $content=template("mail.erb")
#    mail{
#            "mail_$username":
#            email=>$email,
#            title=>"Account_Created",
#            content =>$content,
#            subscribe=>User["add_$username"]
#        }
#    }

}

