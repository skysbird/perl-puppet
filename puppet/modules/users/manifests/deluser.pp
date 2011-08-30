define del_user($username)
{
       user
       {
           $username:
           ensure  => absent,
       }
}

define del_user_with_home($username)
{
#TODO:hestinate to rm -rf /home/$username ,it's so dangours
       user
       {
           $username:
           ensure  => absent,
           managehome =>true
       }


}
