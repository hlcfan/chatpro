# coding: utf-8
require "socket"
JUGGERNAUT_SERVER = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
WillPaginate::ViewHelpers.pagination_options[:previous_label] = "旧一点"
WillPaginate::ViewHelpers.pagination_options[:next_label] = "新一点"