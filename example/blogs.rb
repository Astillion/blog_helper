# (c) 2016, Astillion Ltd, Matthew Smith. <bloghelper@astillion.com>
#
# This file is part of Blog Helper
#
# Blog Helper is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Blog Helper is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Blog Helper.  If not, see <http://www.gnu.org/licenses/>.

########################################################

require 'sinatra/base'
require 'date'
require 'yaml'
require 'cgi'

module Sinatra
    module Blogs
		  YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m
      BLOGS_DIR = 'blogs/'
      
      def get_date(filename)
        date = DateTime.parse(filename.split("/")[1].split("_")[0])
        return date
      end

      def get_title(filename, raw=false)
        if raw
          title = filename.split("_")[1].split('.')[0]
        else
          header = get_header_or_blog(filename,'header')
          if header.has_key?("title")
            title = header["title"]
          else
            title = filename.split("_")[1].split('.')[0].gsub('-',' ')
          end
        end
        return title
      end

      def sort_blogs(array)
        #Sort the array
        sorted = array.sort { |a,b| b[:date] <=> a[:date] }
        return sorted
      end

      def get_header_or_blog(fn,type)
        if File.exists?(fn)
          #
          # see:  https://github.com/jekyll/jekyll/blob/57fd5f887da1189a16bdfbb982d75f725c38d725/lib/jekyll/document.rb#L408
          #       https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Variables_and_Constants#cite_note-English-1
          content = File.read(fn)
          if content =~ YAML_FRONT_MATTER_REGEXP
            # $' = POSTMATCH
            header = $&
            blog = $'
          end
          blog_content = blog
          begin
            header_content = YAML.load(header)
            if type == 'blog'
              return blog_content
            else
              return header_content
            end
          rescue
            return {error: "Blog with name #{fn} has a formatting error"} 
          end
        else
          return {error: "Blog with name #{fn} not found"} 
        end
      end

      def get_blogs()
        #Array of Blogs
        blogs = Array.new

        #Get all files and order them by date
        Dir[BLOGS_DIR + "*.yml"].each do |blog|
          blog_details = get_header_or_blog(blog,'header')
          if !blog_details.has_key?(:error)
            blogs.push({date: get_date(blog), blog_title_raw: CGI.escape(get_title(blog, true)), blog_title: get_title(blog), blog_header_img: blog_details["header_img"], synopsis: blog_details["synopsis"]})
          else
            puts blog_details
          end
        end
        return sort_blogs(blogs)
      end

      def get_blog(fn)
        post = Hash.new
        post[:blog] = get_header_or_blog(BLOGS_DIR+fn,'blog')
        post[:header] = get_header_or_blog(BLOGS_DIR+fn,'header')
        puts post[:header]
        post[:header][:date] = get_date(BLOGS_DIR+fn)
        if !post[:header].has_key?('title')
          post[:header][:title] = get_title(BLOGS_DIR+fn)
        end
        return post
      end
  end

  helpers Blogs

end
