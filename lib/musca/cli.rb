module Musca
  class CLI < Thor
    include Thor::Actions

    source_root(
      File.expand_path(
        File.join(
          File.dirname(__FILE__), '..', '..', 'templates'
        )))

    desc 'create', 'configure CA hierarchy'
    method_option :dir,
                  type: :string,
                  banner: 'CA directory',
                  default: Dir.pwd
    def create
      destination_root = File.expand_path(options.dir)
      @ca_tool[:directory] = destination_root

      # empty_directory destination_root
      template 'ca_config.yml.tt', File.join(destination_root, 'ca_config.yml')
      inside destination_root do
        create_file 'ca_serial.txt', 1
        empty_directory 'certs'
        empty_directory 'keys'
        empty_directory 'requests'
      end
    end

    desc 'genkeys', 'generate root key and cert'
    method_option :dir,
                  type: :string,
                  banner: 'CA directory',
                  default: Dir.pwd
    method_option :config,
                  type: :string,
                  banner: 'CA config file',
                  default: 'ca_config.yml'
    def genkeys
      config_fileFile.join(options[:dir], options[:config])
      new_ca = Musca::CertAuthority.new(config_file: config_file)
      new_ca.create
    end

    desc 'newcert', 'create and sign a new keypair and certificate'
    method_option :config,
                  type: :string,
                  required: :true,
                  banner: 'CA configuration file',
                  default: File.join(Dir.pwd, 'ca_config.yml')
    method_option :certclass,
                  type: :string,
                  required: :true,
                  banner: "'server' or 'client'"
    method_option :hostname,
                  type: :string,
                  default: Socket.gethostbyname(Socket.gethostname).first,
                  banner: 'hostname that will be using the cert'

    def newcert
      ca = Musca::CertAuthority.new(config_file: options.config)
      ca.newcert(options.certclass, options.hostname)
    end
  end
end
