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
content = File.open('content.json', 'r').read
all_posts = JSON.parse(content)


# Template all the things \o/
all_posts.each do |post|
    unless post['title'].strip.empty?
        date = Date.strptime(post['date']).to_s

        p = Post.new post['title'].gsub('"','\''), post['date'], post['author'], post['content']['html']
        filename = date + '-' + p.slug + '.html'


        File.open('../_posts/' + filename, 'w') do |file|
            template = File.read('post_template.html')
            renderer = ERB.new(template)
            file.write renderer.result(p.get_binding)
            puts 'Successfully created ' + filename
        end
    end
end
