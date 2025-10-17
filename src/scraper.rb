require 'nokogiri'
require 'httparty'
require 'pry'
require 'json'

class Scraper
  attr_accessor :resource

  def initialize(resource: "https://r-2.online/rating/char")
    response = HTTParty.get(resource)
    document = Nokogiri::HTML(response.body)
    @json_top_list = document.css("script").each do |element|
      contents = element.children.first.to_s

      break contents.split(' = ').last.strip if contents[..50].include?('JSON.parse')
    end
  end
  
  def fetch_guilds
    fetch_top_list["_mGuildList"]
  end
  
  def fetch_characters
    fetch_top_list["_mList"]
  end

  private

  def fetch_top_list
    JSON.parse(@json_top_list[12..@json_top_list.size - 4])
  end
end
