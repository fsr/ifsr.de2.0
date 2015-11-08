#! /usr/bin/env ruby

require 'json'
require 'erb'
require 'date'

class Post
    def initialize(title, date, author, content)
        @title = title
        @slug = replaceChars title
        @date = date
        @author = author
        @content = content
    end
    def get_binding
        binding
    end
    attr_reader :slug
end

def replaceChars(s)
    s.gsub(' ', '-')
     .gsub('/', '')
     .gsub('ä', 'ae')
     .gsub('Ä', 'Ae')
     .gsub('ö', 'oe')
     .gsub('Ö', 'Oe')
     .gsub('ü', 'ue')
     .gsub('Ü', 'ue')
     .gsub('ß', 'ss')
     .gsub('.', '')
     .gsub('"', '')
     .gsub('\'', '')
     .gsub('?', '')
     .gsub('!', '')
     .gsub(':', '')
     .gsub('(', '')
     .gsub(')', '')
     .gsub('--', '-')
end


# Read JSON content
all_posts = []
File.open('content.json', 'r').each_line do |post_page|
    JSON.parse(post_page).each do |post|
        all_posts << post
    end
end


# Sort content
all_posts = all_posts.sort_by do |post|
    post['date']
end
all_posts.reverse!


# Template all the things
all_posts.each do |post|
    unless post['title'].strip.empty?
        date = Date.strptime(post['date']).to_s

        p = Post.new post['title'].gsub('"','\''), post['date'], post['author'], post['content']['html']
        filename = date + '-' + p.slug + '.html'

        puts filename

        File.open('../_posts/' + filename, 'w') do |file|
            template = File.read('post_template.html')
            renderer = ERB.new(template)
            file.write renderer.result(p.get_binding)
            puts 'Successfully created file ' + filename
        end
    end
end
