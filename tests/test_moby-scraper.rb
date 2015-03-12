require 'moby-scraper'
require 'test/unit'
require 'test_helper'

class TestMoby < Test::Unit::TestCase
  def test_fetch_k7
    game = MobyScraper::MobyScraper.new('killer7')
    game_meta = game.get_meta
    assert(game_meta[:published_by].include? "Capcom")
    assert(game_meta[:developed_by].length == 2)
    assert(game_meta[:theme].length == 2)
    assert(game_meta[:theme].include? "Puzzle-Solving")
    assert(game_meta[:name] == "Killer7")
  end

  def test_exception
    assert_raise ArgumentError do
      game = MobyScraper::MobyScraper.new("nonsense-string-probably-not-a-game")
    end
  end

  def test_cover
    game = MobyScraper::MobyScraper.new('killer7')
    cover = game.get_cover
    assert_equal(cover, "http://mobygames.com/images/covers/large/1141368072-00.jpg")
  end

  def test_shots
    game = MobyScraper::MobyScraper.new('atomic-protector')
    cover = game.get_cover
    assert_equal(cover, "http://mobygames.com/images/shots/l/649401-atomic-protector-bbc-micro-screenshot-title-screens.jpg")
  end
end
