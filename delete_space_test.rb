#
# The contents of this file are subject to the license and copyright
# detailed in the LICENSE and NOTICE files at the root of the source
# tree and available online at
#
#     http://duracloud.org/license/
#

require_relative 'storage_provider_test_base'

#
# This class...
#
# @author Andrew Woods
#         Date: May 08, 2012
#
class DeleteSpaceTest < StorageProviderTestBase

  def do_test
    puts "Delete Space Test"
    test_stores_delete_space
  end

  def test_stores_delete_space
    @stores.each_key do |storeId|
      puts "testing: #{@stores[storeId]}"
      time("store", storeId) { test_delete_space(storeId) }
    end
  end

  def test_delete_space(storeId)
    time("deleting spaces", storeId) {
      first_space.upto(last_space) do |i|
        remove_space("#{@spaceId}-#{i}", storeId)
      end
    }

    time("verifing deletion", storeId) {
      first_space.upto(last_space) do |i|
        uri = "#{@base_url}/durastore/#{@spaceId}-#{i}?storeID=#{storeId}"
        res = @clnt.head(uri)
        verify_status(res, 404, uri)
      end
    }
  end
end