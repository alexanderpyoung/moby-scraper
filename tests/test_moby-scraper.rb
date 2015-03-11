require 'moby-scraper'
require 'test/unit'

class TestMoby < Test::Unit::TestCase
  def test_fetch_k7()
    game = MobyScraper::MobyScraper.new('killer7')
    assert(game.publisher.include? "Capcom")
    assert(game.developer.length == 2)
    assert(game.developer[0].include? "Capcom")
    assert(game.developer[1].include? "grasshopper")
  end

  def test_fetch_007()
    game = MobyScraper::MobyScraper.new('007-agent-under-fire')
    assert_equal(game.publisher, "Electronic Arts, Inc.")
    assert(game.developer.length == 2)
    assert_equal(game.developer[0], "Electronic Arts Canada")
    assert_equal(game.released, "Nov 15, 2001")
    assert(game.platforms.length == 3)
  end

  def test_exception()
    assert_raise ArgumentError do
      game = MobyScraper::MobyScraper.new("nonsense-string-probably-not-a-game")
    end
  end
end
