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
class ContentPropertyTest < StorageProviderTestBase

  def do_test
    puts "Content Property Test"
    test_stores_properties
  end

  def test_stores_properties
    @stores.each_key do |storeId|
      puts "testing: #{@stores[storeId]}"
      time("store", storeId) { test_properties(storeId) }
    end
  end

  def test_properties(storeId)
    headers = {'Content-Type' => 'text/plain', 'x-dura-meta-color' => 'green'}

    time("add properties", storeId) {
      first_item.upto(last_item) do |i|
        add_property(@spaceId, storeId, "file-#{i}.txt", headers)
      end
    }

    time("get properties", storeId) {
      first_item.upto(last_item) do |i|
        get_property(@spaceId, storeId, "file-#{i}.txt", headers)
      end
    }
  end

  def add_property(spaceId, storeId, content_id, headers)
    uri = "#{@base_url}/durastore/#{spaceId}/#{content_id}?storeID=#{storeId}"

    begin
      res = @clnt.post(uri, {:header => headers})
      verify_status(res, 200, uri)

    rescue Exception => e
      get_logger.error("Failure: uri=#{uri}, store=#{@stores[storeId]}, err: #{e}")
    end
  end


  def get_property(spaceId, storeId, content_id, headers)
    uri = "#{@base_url}/durastore/#{spaceId}/#{content_id}?storeID=#{storeId}"

    begin
      res = @clnt.head(uri)
      verify_status(res, 200, uri)
      headers.each_key do |key|
        unless headers[key] == res.header[key][0]
          get_logger.error("missing header: #{key}, #{res.dump} uri=#{uri}, store=#{@stores[storeId]}")
        end
      end

    rescue Exception => e
      get_logger.error("Failure: uri=#{uri}, store=#{@stores[storeId]}, err: #{e}")
    end
  end
end