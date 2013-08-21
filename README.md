

Jam\_Func
=================

Not ready.


Use It (when it's ready)
======

```rb
  gem install "Jam_Func"
```

```rb

  require "Jam_Func"

  j = Jam_Func.new

  j.on "create User", lambda { |o|
    User.create o[:name], o[:fav_book]
  }

  j.on "before create User", lambda { |o, last, jam|
    if name_is_taken o[:name]
      jam.error("name taken", o[:name])
    end
  }

  j.run('create User')

```

Alternatives
============

Lots. But, I could not find some this simple and
down to the point. Let me know in the issues
if you find something better than this.

```rb
   Better == Just_As_Simple_But_Better_Maintained
```
