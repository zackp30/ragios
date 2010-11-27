require 'rubygems'
require "bundler/setup"

require 'lib/ragios'

class TestMySite < Ragios::Monitors::TestHTTP
   def initialize
      @time_interval = '1m'
      @notification_interval = '5m'
      @contact = "obi.akubue@gmail.com"
      @test_description = "Http connection to my blog"
      @test_domain = "obi-akubue.org"
      super
   end
  
   def notify   
      gmail_notify
      #email_notify
      #tweet_notify
   end
end

class TestBlogURL <  Ragios::Monitors::TestURL   
   def initialize
      @time_interval = '1m'
      @notification_interval = '6h'
      @contact = "obi.akubue@gmail.com"	
      @test_description  = "My Website Test"
      @test_url = "http://www.whisperservers.com/blog/" 
      super
   end

   def notify   
      gmail_notify
      #email_notify
      #tweet_notify
   end
end

tests = [TestMySite.new, TestBlogURL.new]

ragios = Ragios::Schedulers::RagiosScheduler.new tests 
ragios.init
ragios.start
