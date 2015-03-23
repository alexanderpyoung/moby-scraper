require 'nokogiri'
require 'open-uri'
require 'elasticsearch'
require_relative './lib/moby-scraper'

def thread_func(game, index)
  title = MobyScraper::MobyScraper.new(game)
  puts title.get_meta
  save = MobyScraper::MobySaver.new(title)
  saved = save.save(index)
  if saved == false
    puts "#{title.get_meta[:name]} not saved"
  end
end

es_client = Elasticsearch::Client.new log: false
game_array_es = es_client.get index: 'games', type: 'game_array', id: 'game_list'
game_array_full = game_array_es["_source"]["array"]
game_array = game_array_full[0..(game_array_full.length - 1)]
game_thread_array = Array.new
game_no = 1

game_array.each do |game_url_slug|
  puts "Game number #{game_no} of #{game_array.length}"
  game_thread_array << Thread.new {
    thread_func(game_url_slug, "games")
  }
  if game_thread_array.length == 8
    game_thread_array.each do |thread|
      thread.join
    end
    game_thread_array = Array.new
  end
  game_no += 1
end

if game_thread_array.length != 0
    game_thread_array.each do |thread|
      thread.join
    end
end
