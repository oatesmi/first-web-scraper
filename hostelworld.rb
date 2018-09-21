require 'HTTParty'
require 'nokogiri'
require 'JSON'
require 'csv'

page = HTTParty.get('http://www.hostelworld.com/hostels/San-Francisco')
nokogiri_page = Nokogiri::HTML(page)

prices_array = []

nokogiri_page.css('#fabResultsContainer').css('span.price').each do |price|
  price = price.text.delete('From: US$')
  prices_array.push(price.to_i).compact
end

prices_array = prices_array.select.with_index { |_, i| i.odd? }

CSV.open('sanfrancisco.csv', 'w') do |csv|
  csv << prices_array
end
