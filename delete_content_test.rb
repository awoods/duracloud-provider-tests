#
# The contents of this file are subject to the license and copyright
# detailed in the LICENSE and NOTICE files at the root of the source
# tree and available online at
#
#     http://duracloud.org/license/
#

require_relative 'storage_provider_test_base'

#
# This class performs tests of deleting content.
#
# @author Andrew Woods
#         Date: May 08, 2012
#
class DeleteContentTest < StorageProviderTestBase

  def do_test
    puts "Delete Content Test"
    test_stores_delete_content
  end

  def test_stores_delete_content
    @stores.each_key do |storeId|
      puts "testing: #{@stores[storeId]}"
      time("store", storeId) { delete_items(storeId) }
      #time("store", storeId) { test_delete_content(storeId) }
    end
  end

  #def test_delete_content(storeId)
  #  time("deleting content", storeId) {
  #    marker = delete_items(storeId, nil)
  #    while not marker.nil?
  #      marker = delete_items(storeId, marker)
  #    end
  #  }
  #end

  #def delete_items(storeId, marker)
  #  uri = "#{@base_url}/durastore/#{@spaceId}?storeID=#{storeId}&maxResults=70&marker=#{marker}"
  #  res = @clnt.get(uri)
  #
  #  items = REXML::Document.new(res.body)
  #  if items.get_elements("space/item").length == 0
  #    return nil
  #
  #  else
  #    items.elements.each("space/item") do |item|
  #      marker = item.text
  #      delete_content(@spaceId, storeId, marker)
  #    end
  #    return marker
  #  end
  #end

  def delete_items(storeId)
    time("deleting content", storeId) {
      first_item.upto(last_item) do |i|
        delete_content(@spaceId, storeId, "file-#{i}.txt")
      end
    }

  end

  def delete_content(spaceId, storeId, content_id)
    uri = "#{@base_url}/durastore/#{spaceId}/#{content_id}?storeID=#{storeId}"

    begin
      res = @clnt.delete(uri)
      verify_status(res, 200, uri)

    rescue Exception
      get_logger.error("Failure: uri=#{uri}, store=#{@stores[storeId]}")
    end
  end
end
