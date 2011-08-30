class default_groups
{

       group
       { "ops":
	 gid=>'5000',
         ensure=>present,
       }

       group
       { "engineer":
	 gid=>'5001',
         ensure=>present,
       }

       group
       { "sudoer":
	 gid=>'5002',
         ensure=>present,
       }

}
