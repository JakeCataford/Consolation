Consolation
------

![](https://www.dropbox.com/s/4fwvqs9l7j8fx7d/Screenshot%202014-04-24%2016.43.30.png)

*Consolation:* a console log widget for rails.

Print color escaped console output by calling `<%= console @your_log_output%>`

Great for apps that need to display console output, such as CI platforms.

renders with _solarized's_ color scheme in a monospace font, or `inconsolata` if you load it with google fonts.

provides line numbering either automatically or manually.


Setup
-----

1. add `gem 'consolation', git: "https://github.com/jakecataford/consolation` to your gemfile and `bundle install`.
2. require the css and javascript in the controllers where you want to display a console via sprockets:

   For example, in `application.js` you could do:
   ```
   //= require consolation
   ```

   and in `application.css` you could do:
   ```
   //= require consolation
   ```

3. Include the module in your application helper:

  ```Ruby
  module ApplicationHelper
    include Consolation
  end
  ```

4. Then in your erb views just call the helper:

  ```Ruby
  <%= console @some_string_with_the_console_output %>
  ```

Features
----

- Consolation will auto link urls it finds in the text
- It will automatically escape ANSI color codes and display them in color
- It automatically copies lines to the clipboard on a drag

- you can make it scrollable by setting a height, this is a max height:

```Ruby
<%= console @console_output, height: 400 %>
```

- You can truncate logs by specifying a maximum length:

```Ruby
<%= console @console_output, truncate_to: 150 %>
```


