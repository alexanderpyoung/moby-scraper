require 'open-uri'
require 'nokogiri'

module MobyScraper
  class MobyScraper
    def initialize(game)
      @mg_page = Nokogiri::HTML(open("http://www.mobygames.com/game/#{game}"))
      if @mg_page.at_css('title').text.include? '{gameTitle}'
        raise ArgumentError, 'The game cannot be found in MD. This game may not exist.'
      end
    end
        
    def get_meta
      
      # just in case, we can use this to replace nbsps with proper spaces
      nbsp_nokogiri = Nokogiri::HTML('&nbsp;').text
      
      meta = Hash.new
      css_selectors = ['#coreGameRelease div', '#coreGameGenre div div']
      css_selectors.each do |selector|
        lhs_meta = @mg_page.css(selector)
        (0..lhs_meta.length - 1).step(2).each do |number|
          symbol = lhs_meta[number].text.gsub(" ", "_").downcase.to_sym
          
          # we will want some of our values to be arrays of things (themes, genres etc)
          # but not all, obviously

          value_initial = lhs_meta[number + 1].text.split(", ")
          if value_initial.length == 1
            value_keep = value_initial[0]
          else
            value_keep = value_initial
          end
          meta[symbol] = value_keep
        end
      end
      return meta
    end

    def get_cover
      cover_rel_url = @mg_page.at_css("#coreGameCover img")['src']
      cover_split_url = cover_rel_url.split('/')
      cover_end_url = cover_split_url.last
      
      # sometimes we have screenshots, sometimes cover art
      
      if cover_rel_url.include? '/shots/'
        cover_abs_url = 'http://mobygames.com/images/shots/l/' + cover_end_url
      else
        cover_abs_url = 'http://mobygames.com/images/covers/large/' + cover_end_url
      end
      return cover_abs_url
    end

    def fetch_image
      image_data = open(self.get_cover)
      return image_data
    end
  end
end
