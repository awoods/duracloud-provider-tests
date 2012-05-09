#
# The contents of this file are subject to the license and copyright
# detailed in the LICENSE and NOTICE files at the root of the source
# tree and available online at
#
#     http://duracloud.org/license/
#

require_relative 'storage_provider_test_base'

#
# This class performs tests of creating spaces.
#
# @author Andrew Woods
#         Date: May 08, 2012
#
class CreateSpaceTest < StorageProviderTestBase

  def do_test
    puts "Create Space Test"
    test_stores_create_space
  end

  def test_stores_create_space
    @stores.each_key do |storeId|
      puts "testing: #{@stores[storeId]}"
      time("store", storeId) { test_create_space(storeId) }
    end
  end

  def test_create_space(storeId)
    time("creating spaces", storeId) {
      first_space.upto(last_space) do |i|
        create_space("#{@spaceId}-#{i}", storeId)
      end
    }

    time("verifing spaces", storeId) {
      first_space.upto(last_space) do |i|
        uri = "#{@base_url}/durastore/#{@spaceId}-#{i}?storeID=#{storeId}"
        res = @clnt.head(uri)
        verify_status(res, 200, uri)
      end
    }
  end

end
