Facter.add("etcpasswd") do
        setcode do
                File.read('/etc/passwd')
        end
end
