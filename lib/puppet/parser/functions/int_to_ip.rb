require "ipaddr"
module Puppet::Parser::Functions

  newfunction(:int_to_ip, :type => :rvalue, :doc => <<-'ENDHEREDOC'
    Converts a dotted address of the form 192.168.0.1 into its 32 bit integer representation

    ENDHEREDOC
    ) do |args|

    if args.length > 3 or args.length < 1 then
      raise Puppet::ParseError, ("int_to_ip(): wrong number of arguments (#{args.length}; must be 1-3)")
    end
    ip = args[0]
    if args[1] then
        family = args[1]
    else
        family = 'inet'
    end
    if args[2] then
        output = args[2]
    else
        output = 'compact'
    end
    myint = Integer(ip) rescue false
    if myint == false then
        raise Puppet::ParseError, ("#{ip.inspect} is not a integer. It looks to be a #{ip.class}")
    end

    begin
      if family == "inet" then
        ipaddr = IPAddr.new(myint, Socket::AF_INET)
      elsif family == "inet6" then
        ipaddr = IPAddr.new(myint, Socket::AF_INET6)
      else
        raise Puppet::ParseError, ("family #{family.inspect} should be inet|inet6")
      end
    rescue ArgumentError => e
      raise Puppet::ParseError(e)
    end
    if output == 'compact' then
      ipaddr.to_s
    elsif output == 'long' then
      ipaddr.to_string
    elsif output == 'bare' then
      ipaddr.to_string.gsub(":", "")
    else
      raise Puppet::ParseError, ("output #{output.inspect} should be long|compact|bare")
    end
  end
end
