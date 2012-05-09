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
class ContentMD5Test < StorageProviderTestBase

  def do_test
    puts "Content MD5 Test"
    test_stores_md5
  end

  def test_stores_md5
    @stores.each_key do |storeId|
      puts "testing: #{@stores[storeId]}"
      time("store", storeId) { test_md5(storeId) }
    end
  end

  def test_md5(storeId)
    time("checking md5", storeId) {
      expected_md5 = Digest::MD5.file(@test_file)
      first_item.upto(last_item) do |i|
        check_md5(@spaceId, storeId, "file-#{i}.txt", expected_md5)
      end
    }
  end

  def check_md5(spaceId, storeId, content_id, expected_md5)
    uri = "#{@base_url}/durastore/#{spaceId}/#{content_id}?storeID=#{storeId}"

    begin
      res = @clnt.head(uri)
      verify_status(res, 200, uri)

      unless expected_md5 == res.header['Content-MD5'][0]
        get_logger.error("md5 mismatch: uri=#{uri}, store=#{@stores[storeId]}")
      end

    rescue Exception => e
      get_logger.error("Failure: uri=#{uri}, store=#{@stores[storeId]}, err: #{e}")
    end
  end
end