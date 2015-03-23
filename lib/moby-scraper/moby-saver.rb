require 'elasticsearch'
require 'date'

module MobyScraper
  class MobySaver
    def initialize(scraper)
      @scraper = scraper
      if @scraper.class != MobyScraper
        raise ArgumentError, "Object passed was not a MobyScraper object"
      end
      @data = @scraper.get_meta
      if @data[:released]
        # we may be passed a date in the format ["Mmm dd", "yyy"]
        if @data[:released].class == Array
          mmm_dd = @data[:released][0].split(" ")
          @data[:released] = date_to_ruby_date(mmm_dd.push(@data[:released][1]))
        elsif @data[:released].class == String and @data[:released].length == 4 # eg, "1984"
          yyyy = Array.new
          yyyy.push(@data[:released])
          @data[:released] = date_to_ruby_date(yyyy)
        elsif @data[:released] == "Unknown"
          @data[:released] = Date.new(0)
        else
          @data[:released] = date_to_ruby_date(@data[:released].gsub(", ", " ").split(" "))
        end
      end
    end

    def date_to_ruby_date(mg_date)
      if mg_date.length == 3
        new_date = Date.strptime(mg_date.to_s, '["%b", "%d", "%Y"]')
      elsif mg_date.length == 2
        new_date = Date.strptime(mg_date.to_s, '["%b", "%Y"]')
      else
        new_date = Date.strptime(mg_date.to_s, '["%Y"]')
      end
      return new_date
    end
    
    def save(es_index)
      client = Elasticsearch::Client.new log: false
      index = client.index index: es_index, type:'games', id: @scraper.slug, body: @data
      return index["created"]
    end
  end
end
