module Puppet::Parser::Functions
  newfunction(:mail, :type => :rvalue) do |args|
    %x{/bin/echo '#{args[2]}' | /usr/bin/mail #{args[0]} -s #{args[1]} -b test@i-waihui.com -a 'MIME-Version: 1.0' -a 'Content-Type: text/html; charset=iso-8859-1' }
  end
end 
