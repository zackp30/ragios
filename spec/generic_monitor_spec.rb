require 'spec_base.rb'

module Ragios
  module Notifier
    class TestNotifier 
      def initialize(monitor)
      end
      def failed
      end
      def resolved
      end
    end
 end
end

module Ragios
  module Plugin
    class BasePlugin
      def init(options)
      end
    end
  
    class PassingPlugin < BasePlugin
      attr_reader :test_result
      def test_command
        @test_result = :test_passed
        return true
      end
    end

    class FailingPlugin < BasePlugin
      attr_reader :test_result
      def test_command
        @test_result = :test_failed
        return false
      end
    end

    class NoTestCommandPlugin < BasePlugin
    end

    class NoTestResultPlugin < BasePlugin
      def test_command
        return false
      end
    end
  end
end

describe Ragios::GenericMonitor do

  it "should pass the test" do
    options = {monitor: "something",
               _id: "monitor_id",
               via: "test_notifier",
               plugin: "passing_plugin" }
   generic_monitor = Ragios::GenericMonitor.new(options) 
   generic_monitor.test_command.should == true
   generic_monitor.test_result.should == :test_passed
   generic_monitor.state.should == "passed"
   generic_monitor.passed?.should == true
  end   
  
  it "should fail the test" do
    options = {monitor: "something",
               _id: "monitor_id",
               via: "test_notifier",
               plugin: "failing_plugin" }
    generic_monitor = Ragios::GenericMonitor.new(options) 
    generic_monitor.test_command.should == false
    generic_monitor.test_result.should == :test_failed
    generic_monitor.state.should == "failed"
    generic_monitor.failed?.should == true    
  end
  
  it "should throw exception if no plugin.test_command defined" do
    options = {monitor: "something",
               _id: "monitor_id",
               via: "test_notifier",
               plugin: "no_test_command_plugin" }
    generic_monitor = Ragios::GenericMonitor.new(options) 
    expect { generic_monitor.test_command }.to raise_error(Ragios::PluginTestCommandNotFound)  
  end
  
  it "should throw exception if no plugin.test_result" do
    options = {monitor: "something",
               _id: "monitor_id",
               via: "test_notifier",
               plugin: "no_test_result_plugin" }
    generic_monitor = Ragios::GenericMonitor.new(options) 
    expect { generic_monitor.test_command }.to raise_error(Ragios::PluginTestResultNotFound)  
  end
  
end

describe "GenericMonitor initial states" do 
  it "should set state passed" do
    options = {monitor: "something",
               _id: "monitor_id",
               via: "test_notifier",
               state_: "passed",
               plugin: "failing_plugin" }
    generic_monitor = Ragios::GenericMonitor.new(options) 
    generic_monitor.passed?.should == true
  end
  
  it "should set state failed" do
    options = {monitor: "something",
               _id: "monitor_id",
               via: "test_notifier",
               state_: "failed",
               plugin: "passing_plugin" }
    generic_monitor = Ragios::GenericMonitor.new(options)  
    generic_monitor.failed?.should == true
  end   
  
  it "should set state pending" do
    options = {monitor: "something",
               _id: "monitor_id",
               via: "test_notifier",
               plugin: "passing_plugin" }
    generic_monitor = Ragios::GenericMonitor.new(options) 
    generic_monitor.pending?.should == true
  end   
end