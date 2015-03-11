require 'open-uri'
require 'nokogiri'

module MobyScraper
    class MobyScraper
        attr_reader :publisher, :developer, :released, :platforms, :cover_end_url
        attr_reader :cover_abs_url, :genre, :perspective, :theme_csv, :game_name

        def initialize(game)
          nbsp_nokogiri = Nokogiri::HTML('&nbsp;').text

          @game_name = game  
          mg_page = Nokogiri::HTML(open("http://www.mobygames.com/game/#{game}"))

            if !mg_page.at_css('title').text.include? '{gameTitle}'
              # the publishers and developers have nbsps in their names. Nokogiri to_ses these literally.
              # the gsub replaces the nbsp with normal spaces 

              @publisher = mg_page.css('#coreGameRelease div')[1].text.gsub(nbsp_nokogiri, " ")
              @developer = mg_page.css('#coreGameRelease div')[3].text.gsub(nbsp_nokogiri, " ").split(", ")
                
              @released = mg_page.css('#coreGameRelease div')[5].text
              @platforms = mg_page.css('#coreGameRelease div')[7].text.split(", ")

              # the image URLs on MG are relative to domain root. Some light string
              # manipulation here to deal with this, and to get the larger image.
              # we also need to differentiate between games with cover images and games with
              # stand-in cover images.

              cover_rel_url = mg_page.css('#coreGameCover img').first['src']
              cover_split_url = cover_rel_url.split('/')
              @cover_end_url = cover_split_url[cover_split_url.length - 1]
              if cover_rel_url.include? '/shots/'
                  @cover_abs_url = 'http://www.mobygames.com/images/shots/l/' + @cover_end_url
              else
                  @cover_abs_url = 'http://www.mobygames.com/images/covers/large/' + @cover_end_url
              end

              @genre = mg_page.css('#coreGameGenre div div')[1].text
              @perspective = mg_page.css('#coreGameGenre div div')[3].text
              @theme_csv = mg_page.css('#coreGameGenre div div')[5].text.split(", ")

          else
              raise ArgumentError, 'The game cannot be found in MD. This game may not exist.'
          end

          def save_image
            image_data = open(self.cover_abs_url).read
            destination = File.open(self.cover_end_url, 'wb')
            destination.write(image_data)
            return true
          end
        end
    end
end

