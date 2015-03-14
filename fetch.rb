require 'nokogiri'
require 'open-uri'
require_relative './lib/moby-scraper'

def thread_func(game, index)
  title = MobyScraper::MobyScraper.new(game)
  save = MobyScraper::MobySaver.new(title)
  saved = save.save(index)
  if saved == false
    puts "#{title.get_meta[:name]} not saved"
  end
end

page_total_items = Nokogiri::HTML(open("http://www.mobygames.com/browse/games/offset,0/so,0a/list-games/").read)
total_items = page_total_items.at_css(".mobHeaderItems").text.split(" of ").last.gsub!(")", "").to_i
game_array = Array.new
thread_array = Array.new
game_thread_array = Array.new

(0..total_items).step(25).each do |number|
  thread_array << Thread.new {
    puts "Starting page number #{(number/25)}"
    game_set_page = Nokogiri::HTML(open("http://www.mobygames.com/browse/games/offset,#{number}/so,0a/list-games/"))
    game_set_page.css("#mof_object_list tbody tr").each do |game_row|
      game_array.push(game_row.css("td a").first[:href].split("/").last)
    end
    }
  if thread_array.length == 5
      thread_array.each do |thread|
        thread.join
      end
      thread_array = Array.new
      puts "#{game_array.length} games so far."
  end
end

game_array.each do |game_url_slug|
  game_thread_array << Thread.new {
    thread_func(game_url_slug, "games")
  }
  if game_thread_array.length == 5
    game_thread_array.each do |thread|
      thread.join
    end
    game_thread_array = Array.new
  end
end
