require 'OpenSSL'
require 'socket'
require 'io/console'
module Musca
  module CertHelper
    SUBJECT_ATTRIBUTES={
	  "Organization" => "O",
	  "Department" => "OU"
	}
	def subject_attributes
	  SUBJECT_ATTRIBUTES
	end
	def get_password(prompt="enter password: ")
      print prompt
      password=STDIN.noecho(&:gets).strip
	  print "\n"
	  password
    end
	def gen_pkey
	  OpenSSL::PKey::RSA.new(2048)
	end
	def my_hostname
      Socket.gethostbyname(Socket.gethostname).first
    end
	def host_dn_for_ca(ca_cert,hostname)
	  ca_dn=ca_cert.subject.to_a
	  new_dn=ca_dn.slice(0,ca_dn.length-1).collect {|n| n[0..1]}
	  new_dn.push(["CN",hostname])
	  OpenSSL::X509::Name.new(new_dn)
	end
	
	def gen_req(key,host=my_hostname,cacert=nil)
	  req=OpenSSL::X509::Request.new
	  req.version=0
	  dn_pieces=[]
	  puts "Enter certificate subject attributes"
	  if cacert.nil?
	    subject_attributes.each do |prompt, attr|
	      print "%s: " % prompt
	      attr_value=STDIN.gets.chomp
		  dn_pieces.push([attr.to_s, attr_value])
	    end
	  else
	    cacert.subject.to_a.slice(0,2).collect {|n| n[0..1]}.each {|d| dn_pieces.push d}
	  end
	  dn_pieces.push(["CN",host])
	  
	  req.subject=OpenSSL::X509::Name.new(dn_pieces)
	  req.public_key=key.public_key
	  req.sign(key,OpenSSL::Digest::MD5.new) 
	  req
	end
	def next_serial(file)
	  cur_serial=File.read(file).strip.to_i
	  new_serial=cur_serial + 1
	  File.open(file,"w") {|f| f.write(new_serial) }
	  new_serial
	end
  end
end
