# coding: utf-8
require "socket"

WillPaginate::ViewHelpers.pagination_options[:previous_label] = "新一点"
WillPaginate::ViewHelpers.pagination_options[:next_label] = "旧一点"
case ENV['RAILS_ENV']  
  when "development"
    JUGGERNAUT_SERVER = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
  when "production"  
    JUGGERNAUT_SERVER = "106.187.94.74"
end