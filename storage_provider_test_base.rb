#
# The contents of this file are subject to the license and copyright
# detailed in the LICENSE and NOTICE files at the root of the source
# tree and available online at
#
#     http://duracloud.org/license/
#

require 'rubygems'
require 'rexml/document'
require 'httpclient'
require 'digest/md5'
require 'logger'

#
# This class is the base class of functional tests.
#
# @author Andrew Woods
#         Date: May 08, 2012
#
class StorageProviderTestBase

  def get_logger
    log_dir = "#{File.expand_path(File.dirname(__FILE__))}/logs"
    unless File::directory?(log_dir)
      Dir.mkdir(log_dir)
    end
    Logger.new("#{log_dir}/#{File.basename($0)}.log", 10, 512000)
  end

  def initialize(base_url, username, password, offset=0)
    @base_url = base_url
    @spaceId = "api-test-space"

    ###
    # Edit the below fields as desired.
    ###
    #@test_file = 'resources/one-mg.txt'
    @test_file = 'resources/testfile.txt'

    #@num_items = 1000
    @num_items = 100

    #@num_spaces = 25
    @num_spaces = 5

    @offset = offset

    #@stores = {1 => 'sdsc', 2 => 'rackspace'}
    @stores = {0 => 'amazon', 1 => 'rackspace'}
    #@stores = {0 => 'amazon', 1 => 'sdsc', 2 => 'rackspace', 3 => 'hp'}
    #@stores = {0 => 'amazon'}#, 1 => 'sdsc', 2 => 'rackspace'} #, 3 => 'hp'}

    @clnt = HTTPClient.new
    @clnt.ssl_config.set_trust_ca("/etc/ssl/certs")
    @clnt.set_auth("#{@base_url}/durastore", username, password)
  end

  def create_space(spaceId, storeId)
    uri = "#{@base_url}/durastore/#{spaceId}/?storeID=#{storeId}"
    res = @clnt.put(uri)
    verify_status(res, 201, uri)
  end

  def cleanup
    @stores.each_key do |storeId|
      remove_space(@spaceId, storeId)
    end
  end

  def remove_space(spaceId, storeId)
    uri = "#{@base_url}/durastore/#{spaceId}/?storeID=#{storeId}"
    res = @clnt.delete(uri)
    verify_status(res, 200, uri)
  end

  def first_item
    @num_items * @offset
  end

  def last_item
    (@num_items * (@offset + 1)) - 1
  end

  def first_space
    @num_spaces * @offset
  end

  def last_space
    (@num_spaces * (@offset + 1)) - 1
  end

  def verify_status(res, expected, uri)
    unless res.status == expected
      get_logger.warn("Error: #{res.status} (#{expected}) for #{uri}")
    end
  end

  def time (msg, storeId, &fn)
    start = Time.now
    result = fn.call
    puts "elapsed: #{Time.now - start}, " + msg + " [#{@stores[storeId]}]"
    result
  end

end
