require 'nokogiri'
require 'open-uri'
require 'elasticsearch'

page_total_items = Nokogiri::HTML(open("http://www.mobygames.com/browse/games/offset,0/so,0a/list-games/").read)
total_items = page_total_items.at_css(".mobHeaderItems").text.split(" of ").last.gsub!(")", "").to_i
thread_array = Array.new
game_array = Array.new

(0..total_items).step(25).each do |number|
  thread_array << Thread.new {
    puts "Starting page number #{(number/25)} of #{total_items/25}"
    game_set_page = Nokogiri::HTML(open("http://www.mobygames.com/browse/games/offset,#{number}/so,0a/list-games/"))
    game_set_page.css("#mof_object_list tbody tr").each do |game_row|
      game_array.push(game_row.css("td a").first[:href].split("/").last)
    end
    }
  if thread_array.length == 8
      thread_array.each do |thread|
        thread.join
      end
      thread_array = Array.new
      puts "#{game_array.length} games so far."
  end
end

if thread_array.length != 0
    thread_array.each do |thread|
      thread.join
    end
end


es_client = Elasticsearch::Client.new log: false
es_client.index index: 'games', type: 'game_array', id: 'game_list', body: {array: game_array}
