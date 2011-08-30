define mod_user($username,$groups,$membership)
{
       user
       {   "mod_user_$username":
    	   name=>$username,
           groups => $groups,
           membership=>$membership
       }
	
}

define add_to_sudo($username)
{
	mod_user{
		"mod_user_group_$username":
		username=>$username,
		groups=>"sudoer",
        membership=>"minimum"
	}
}
