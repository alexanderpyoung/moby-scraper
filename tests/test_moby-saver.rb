require 'moby-scraper'
require 'test/unit'
require 'test_helper'

class TestSaver < Test::Unit::TestCase
  def test_error
    assert_raise ArgumentError do
      MobyScraper::MobySaver.new("123")
    end
  end

  def test_date
    game = MobyScraper::MobyScraper.new('killer7')
    save = MobyScraper::MobySaver.new(game)
    assert(save.date_to_ruby_date(["1999"]).to_s.include? "1999-01-01")
    assert(save.date_to_ruby_date(["Jun", "2001"]).to_s.include? "2001-06-01")
    assert(save.date_to_ruby_date(["Jun", "09", "2001"]).to_s.include? "2001-06-09")
  end

  def test_year_only_game
    assert_nothing_raised do
      game = MobyScraper::MobyScraper.new('bipbop-ii')
      save = MobyScraper::MobySaver.new(game)
    end
  end

  def test_save
    game = MobyScraper::MobyScraper.new('olliolli')
    save = MobyScraper::MobySaver.new(game)
    assert(save.save("games_test"))
  end
end

