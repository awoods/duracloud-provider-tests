#
# The contents of this file are subject to the license and copyright
# detailed in the LICENSE and NOTICE files at the root of the source
# tree and available online at
#
#     http://duracloud.org/license/
#

require_relative 'storage_provider_test_base'

#
# This class performs tests of adding content.
#
# @author Andrew Woods
#         Date: May 08, 2012
#
class AddContentTest < StorageProviderTestBase

  def do_test
    puts "Add Content Test"
    test_stores_add_content
  end

  def test_stores_add_content
    @stores.each_key do |storeId|
      puts "testing: #{@stores[storeId]}"
      time("store", storeId) { test_add_content(storeId) }
    end
  end

  def test_add_content(storeId)
    time("creating space", storeId) { create_space_if_needed(@spaceId, storeId) }
    time("adding content", storeId) {
      first_item.upto(last_item) do |i|
        add_content(@spaceId, storeId, "file-#{i}.txt", @test_file)
      end
    }
  end

  def create_space_if_needed(spaceId, storeId)
    uri = "#{@base_url}/durastore/#{spaceId}?storeID=#{storeId}"

    begin
      res = @clnt.head(uri)
      unless res.status == 200
        create_space(spaceId, storeId)
      end

    rescue Exception
      get_logger.error("Failure: uri=#{uri}, store=#{@stores[storeId]}")
    end
  end

  def add_content(spaceId, storeId, contentId, file)
    uri = "#{@base_url}/durastore/#{spaceId}/#{contentId}?storeID=#{storeId}"

    headers = {'Content-Type' => 'text/plain'}
    begin
      res = @clnt.put(uri, {:body => File.open(file), :header => headers})
      verify_status(res, 201, uri)

    rescue Exception
      get_logger.error("Failure: uri=#{uri}, store=#{@stores[storeId]}")
    end
  end

end
