# CLASH Documentation

In this repository you find technical documentation of Clash.

In order to build the documentation, you need [jekyll](https://jekyllrb.com/). Install it and other used ruby gems with 

    $ gem install bundler
    $ bundle install

Generate the page into the `_site` directory with

    $ bundle exec jekyll b

When you are writing documentation and want to check the output, use

    $ bundle exec jekyll liveserve

for (1) continuous building if you change anything in the files, (2) running a local webserver that serves the generated HTML, and (3) sending [livereload](http://livereload.com/) signals to your browser of choice.


## Documentation on this Documentation

If you have rvm or rbenv installed, you probably notice the `.ruby-gemset` and `.ruby-version` files. These are there for opinion reasons.

For writing *UML*, the [jekyll-plantuml plugin](https://github.com/yegor256/jekyll-plantuml) is installed. See more information on plantuml [here](http://plantuml.com/class-diagram)
