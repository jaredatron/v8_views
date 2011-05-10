# V8 Views

## What is it?

V8 Views is a rack middleware javascript template engine powered by V8

## Why?

### Simplifies controllers

  A lot of web frameworks make it too easy to bleed business logic and data acquisition into
  the view layer. Template languages like Mustache/Handlebars make it harder to break out of
  MVC and this is another step in that direction

### Client side rendering

  Another major advantage of rendering your html in JavaScript is the ability to rendering in
  the browser.

## View the example:

    git clone git://github.com/deadlyicon/v8_views.git
    cd v8_views
    rackup
    open http://127.0.0.1:9292/posts
