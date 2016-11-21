# Blog Helper

The Blog helper is a simple Sinatrarb helper that loads blogs from a directory and provides various data structures back to the user to make it simple to extend your ruby sinatra app with Blog content.

Blog helper is not a full featured blog it's goal was to be simple and make use of the surrounding tools to deliver a lot of functionality with minimal effort.

# How it works

Here's a brief overview of why we created it to start with: http://www.astillion.com/blog/2016/11/03/The-Little-Blog-That-Could

Adding a blog to site is simple.

1. Create a new blog file in the blogs directory (located at the root of your web app)

  ```

  vi blogs/yyyy-mm-dd_the-blog-title.yml

  ```

  i.e.

  ```

  vi blogs/2016-11-03_The-Little-Blog-That-Could.yml

  ```

2. Next you need to create a blog with the following content

  ```yaml

  ---
  header_img: '/assets/img/blog/blog_that_could.png'
  synopsis: "I'm a big fan of simplicity and although I'd prefer to have consumed a service in this case adding a couple of Sinatrarb helpers and using git to back the blogs was a better solution and here's why"
  author: "Matthew Smith"
  ---
  <h1>Why build your own?</h1>

  <p>This is a good question. Firstly, I did not want to use wordpress....

  ```

3. Add the following routes to your application

  ```ruby

      #Blogs page
      get '/page_blogs.html' do
        #Pagination start & end points
        if params['start'].nil?
          params['start']=0
        end
        if params['fin'].nil?
          params['fin']=4
        end

        erb :blogs, :locals => {:blogs => get_blogs, :start => params['start'], :finish => params['fin'] }
      end

      get '/blog/:year/:month/:day/:title' do
        erb :blog, :locals => {:blog => get_blog(params['year']+"-"+params['month']+"-"+params['day']+"_"+params['title']+".yml") }
      end

  ```

4. Using the above data structures present the data in a template
**blogs.erb**

  ```html

          <!--=== Content Part ===-->
          <div class="container content">
              <div class="row blog-page">
                  <!-- Left Sidebar -->
                  <div class="col-md-9 md-margin-bottom-40">
                    <% blogs[start.to_i..finish.to_i].each do |blog| %>
                      <!--Blog Post-->
                      <div class="row blog blog-medium margin-bottom-40">
                          <div class="col-md-5">
                              <img class="img-responsive" src="<%= blog[:blog_header_img] %>" alt="">
                          </div>
                          <div class="col-md-7">
                              <h2><a href="blog/<%= blog[:date].strftime("%Y/%m/%d")+"/"+blog[:blog_title_raw] %>"><%= blog[:blog_title] %></a></h2>
                              <ul class="list-unstyled list-inline blog-info">
                                  <li><i class="fa fa-calendar"></i> <%= blog[:date].strftime("%B %d, %Y") %></li>
                              </ul>
                              <p><%= blog[:synopsis] %>...</p>
                              <p><a class="btn-u btn-u-sm" href="blog/<%= blog[:date].strftime("%Y/%m/%d")+"/"+blog[:blog_title_raw] %>">Read More <i class="fa fa-angle-double-right margin-left-5"></i></a></p>
                          </div>
                      </div>
                      <!--End Blog Post-->

                      <hr class="margin-bottom-40">
                      <% end %>
                      <!--Pagination-->
                      <% if blogs.length >= 5 %>
                      <div class="text-center">
                          <ul class="pagination">
                              <% pages = blogs.length / 5
                              index=1 %>
                              <li><a href="?start=0&fin=5">«</a></li>
                              <% while index <= pages %>
                                 <li><a href="?start=<%= index*5 %>&fin=<%= index*5*2 %>"><%= index %></a></li>
                               <%   index+=1
                               end %>
                              <li><a href="?start=<%= index*pages %>&fin=<%= pages+5%>">»</a></li>
                          </ul>
                      </div>
                      <% end %>
                      <!--End Pagination-->
                  </div>
                  <!-- End Left Sidebar -->
             </div><!--/row-->
          </div><!--/container-->
          <!--=== End Content Part ===-->

  ```

**blog.erb**

  ```html

      <!--=== Blog Posts ===-->
      <div class="bg-color-light">
        <div class="container content-sm">
          <div class="row">
            <!-- Blog All Posts -->
            <div class="col-md-9">
            <!-- News v3 -->
            <div class="news-v3 bg-color-white margin-bottom-30">
              <img class="img-responsive full-width" src="<%= blog[:header]['header_img'] %>" alt="">
                  <div class="news-v3-in">
                    <ul class="list-inline posted-info">
                      <li>By <a href="#"><%= blog[:header]['author'] %></a></li>
                      <li>Posted <%= blog[:header][:date].strftime("%B %d, %Y") %></li>
                    </ul>
                    <h2><a href="#"><%= blog[:header][:title] %></a></h2>
                     <p><%= blog[:header]['synopsis'] %></p>
                     <%= blog[:blog] %>
                  </div>
                </div>
                <!-- End News v3 -->
                <hr>
              </div>
              <!-- End Blog All Posts -->
            </div>
          </div><!--/end container-->
      </div>
      <!--=== End Blog Posts ===-->

  ```

4. Eat, Drink and be merry! you're now done.

# Examples

There is a horrible looking example in the [example](example) folder. Check it out.
There is a live version here: http://www.astillion.com/page_blogs.html

# What's next

If you want to keep updated on the progress of this repository you should ensure you are subscribed to the Astillion Blog we will blog occassionally about new features we add as and when we do add them in

There are a number of items at the top of the current wishlist (in no particular order)
* Comments
* Sharring (social)
* Feeds (rss)
* Package as a gem
* Move routing to the helper 
* Provide ability to configure blog helper 

If there are features you want but can not add your self for what ever reason just ping us at bloghelper@astillion.com and we'll see if we can add it in. If it's useful to us we'll do our best to get in in asap.
