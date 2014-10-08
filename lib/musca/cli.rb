require 'pry'
require 'thor'
require 'socket'
require 'musca'
module Musca
  class CLI < Thor
    include Thor::Actions

    source_root(File.expand_path(File.join(File.dirname(__FILE__),'..','..','templates')))  
   
  
    desc "initconfig", "initialize CA hierarchy"
    method_option :dir, 
      :type     => :string, 
      :required => :true, 
      :banner   => "CA directory", 
      :default  => Dir.pwd
    def initconfig
      @ca_tool={}
      say "Initializing CA in #{options.dir}"
      puts "Enter CA base DN"
      print "Organization: "
      o=STDIN.gets.chomp
      print "Department: "
      ou=STDIN.gets.chomp
      destination_root=File.expand_path(options.dir)
      @ca_tool[:base_dn]=OpenSSL::X509::Name.new([["O",o],["OU",ou]]).to_s
      @ca_tool[:directory]=destination_root

      #empty_directory destination_root
      template "ca_config.yml.tt", File.join(destination_root,"ca_config.yml")
      inside destination_root do
        create_file "ca_serial.txt", 1
        empty_directory "certs"
        empty_directory "keys"
        empty_directory "requests"
        new_ca=Musca::CertAuthority.new(config_file: "ca_config.yml")
        new_ca.create
      end
    end
  
  
    desc "newcert", "create and sign a new keypair and certificate"
    method_option :config, 
      :type     => :string, 
      :required => :true, 
      :banner   => "CA configuration file", 
      :default  => File.join(Dir.pwd,"ca_config.yml")
    method_option :certclass, 
      :type => :string, 
      :required => :true, 
      :banner => "'server' or 'client'"
    method_option :hostname,
      :type => :string,
      :default => Socket.gethostbyname(Socket.gethostname).first,
      :banner => "hostname that will be using the cert"
    def newcert
      ca=Musca::CertAuthority.new(config_file: options.config)
      ca.newcert(options.certclass, options.hostname)
    end
  end
end
