require 'cool.io'
require 'stringio'
require 'rocketamf'

module Atoms
  class Server
    
    def self.run(host = "0.0.0.0", port = 5000)
      @server = Cool.io::TCPServer.new(host, port, Atoms::Connection)
      @server.attach(Cool.io::Loop.default)
      puts "Echo server listening on #{host}:#{port}"
      Cool.io::Loop.default.run
    end
  
  end
  
  class Router
    
    attr_accessor :routes
    
    class << self
      
      attr_accessor :endpoints
      
      def config(&block)
        @router = new
        @router.routes = []
        instance_eval(&block)
      end

      def attach(c)
        @router.routes << c.new
      end

      def add(endpoint)
        self.endpoints = [] unless self.endpoints
        self.endpoints << endpoint
      end

      def respond(header, data = {})
        index = endpoints.index{|e| e.header == header}
        endpoint = endpoints[index] if index
        endpoint.call(data) if endpoint # encode to rocket_amf and send back to server
      end 
    end
  end
  
  class Route

    #self.class.to_s
    
    class << self
      
      attr_accessor :ns
            
      def namespace(space = nil, &block)
        @ns ||= []
        @ns << space
        nest(block)
        @ns.delete(space)
      end
      
      alias_method :group, :namespace
      alias_method :resource, :namespace
      alias_method :resources, :namespace
      
      def nest(*blocks)
        blocks.reject!{ |b| b.nil? }
        if blocks.any?
          blocks.each {|b| instance_eval &b} 
        end
      end
            
      def get(path, &block);
        endpoint = Atoms::Endpoint.generate(header(path), &block)
        Atoms::Router.add endpoint
      end      
      
      def header(path)
        parts = []
        parts << self.to_s
        #parts << version.to_s if version
        parts << ns.collect{ |n| n.capitalize }.join('.') if ns
        #parts << ns.to_s.capitalize if ns
        parts << path.to_s.capitalize if path
        p = parts.join('.')
        puts p
        p
      end
    end
  end
  
  class Endpoint
    
    attr_reader :params
    
    def params
      @params ||= {}
    end
    
    def call(prms)
      @params = prms
      response = instance_eval &self.class.block
    end
    
    class << self
      
      attr_accessor :block, :header
      
      def generate(header, &block)
        c = Class.new(Atoms::Endpoint)
        c.class_eval do
          @header = header
          @block = block
        end
        c
      end
      
      def call(prms)
        new.call(prms)
      end           
    end
  end
  
  class Connection < Cool.io::TCPSocket
    
    def on_connect
      #puts "#{remote_addr}:#{remote_port} connected"
      # todo - create a session
    end

    def on_close
      #puts "#{remote_addr}:#{remote_port} disconnected"
      #todo - destroy session
    end

    def on_read(data)
      request = RocketAMF.deserialize(data,3)
      write RocketAMF.serialize(Atoms::Router.respond(request[:header], request[:data]),3)
    end
  end
end
