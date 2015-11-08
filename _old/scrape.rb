#! /usr/bin/env ruby

require 'mechanize'
require 'json'

def parse_page(page)
    posts = []

    page.search('.plugin_include_content').each do |post|
        unless post.search('h1').count == 0
            title = post.at('h1').text
            link = "https://www.ifsr.de#{post.at('h1 a')['href']}"
            date = post.at('.published')['title']
            author = post.at('.author').text
            text = post.at('.level1').text.strip
            html = post.at('.level1').children.to_s.strip


            if post.search('img').count > 0
                img = "https://www.ifsr.de#{post.at('img')['src']}"
            else
                img = nil
            end

            data = {
                :title => title,
                :link => link,
                :date => date,
                :author => author,
                :content => {
                    :text => text,
                    :html => html
                },
                :img => img
            }

            posts << data
        end
    end
    posts
end

mechanize = Mechanize.new
all_posts = []

(0...200).step(10) do |n|
    page = mechanize.get("https://www.ifsr.de/start?first=#{n}")
    puts "Downloading page #{n/10+1}"
    parse_page(page).each do |post|
        all_posts << post
    end
end

File.write('content.json', JSON.pretty_generate(all_posts))
puts "Successfully wrote all content to 'content.json'"
