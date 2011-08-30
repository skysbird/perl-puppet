module Puppet::Parser::Functions
  newfunction(:mkpasswd, :type => :rvalue) do |args|
    %x{/usr/bin/mkpasswd -H MD5 #{args[0]} #{args[1]}}.chomp
  end
end 
