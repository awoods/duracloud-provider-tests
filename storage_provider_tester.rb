#
# The contents of this file are subject to the license and copyright
# detailed in the LICENSE and NOTICE files at the root of the source
# tree and available online at
#
#     http://duracloud.org/license/
#

require_relative "create_space_test"
require_relative 'delete_space_test'
require_relative 'add_content_test'
require_relative 'content_md5_test'
require_relative 'content_property_test'
require_relative 'delete_content_test'

#
# This class...
#
# @author Andrew Woods
#         Date: May 08, 2012
#
class StorageProviderTester

  # main method
  if __FILE__ == $0

    offset = 0
    unless ARGV[0].nil?
      offset = ARGV[0].to_i
    end

    ###
    # base url of duracloud application
    ###
    base_url = "https://andrew.duracloud.org"
    #base_url = "http://localhost:8080"

    ###
    # username/password for duracloud application
    ###
    username = "username"
    password = "password"

    start = Time.now
    puts "Tests begin: #{start}"

    ###
    # select the single test to run
    ###
    #test = CreateSpaceTest.new(base_url, username, password, offset)
    #test = DeleteSpaceTest.new(base_url, username, password, offset)
    test = AddContentTest.new(base_url, username, password, offset)
    #test = ContentMD5Test.new(base_url, username, password, offset)
    #test = ContentPropertyTest.new(base_url, username, password, offset)
    #test = DeleteContentTest.new(base_url, username, password, offset)

    ###
    # select to run the test or clean out the test artifacts
    ###
    test.do_test
    #test.cleanup

    stop = Time.now
    puts "Tests end: #{stop}, elapsed: #{stop - start}"
  end

end
