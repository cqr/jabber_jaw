JabberJaw Makes It Easy To Build Chatbots.
==========================================

Easy, You Say?
--------------

As easy as

    class MyApp < JabberJaw::Application
    
      command :echo do
        message
      end
    
    end.run!
    
Jabber? I Thought We Were Calling It XMPP.
------------------------------------------

Oh, yeah. We are. But it's actually worse than that, because
you can hook it up to multiple adapters with the same logic.

Currently, the following interfaces are __supported__:

  *  STDIN/STDOUT
  
And the following are __planned__:

  *  XMPP
  *  IRC
  *  AIM
  *  Twitter
  
What Else Can I Do?
-------------------

While I have the benefit of building this application twice
before, the syntax still isn't nailed down yet. That said, you
can use RegExps to match messages

    command /^send (.*) to (.*)$/ do |message, recipient|
      send message, :to => recipient
    end
    
or you can use strings. You can automatically split your messages.

    # syntax for the command is `forward <recipient> <message>`
    command :forward do |recipient, message|
      send message, :to => recipient
    end

There's a certain amount of sugar involved. If your block doesn't
send a message and it returns a string, that gets automatically
replied to the sender.

    command /^[aA]m I awesome\?$/ do
      "Yes."
    end

Which is equivalent to

    command /^[aA]m I awesome\?$/ do
      reply "Yes."
    end

or (even more verbose).

    ...
    send "Yes.", :to => sender
    ...
    
There's a bunch more going in, and the code is likely to change
rapidly until I hit a point where it has all the features I want.

There are a lot of them.

Why Version 3?
--------------

It's been done before. I've done it twice before, actually.

JabberJaw started as an internal library for a couple of guys
who didn't know ruby when I was working at a hosting company.
They decided they had to use Ruby because the XMPP library was
so good. That was v1.0

A little later, I started writing a version that the hosting
company *didn't* own, so I called that JabberJaw v2.0. While
working on that, I decided that it should be possible to hook
your bot to a number of services. I wasn't sure how to go about
that, but I finished up 2.0 and used it for a personal project
or two.

Now, I know how to hook it up to multiple adapters(I think),
and it requires a complete rewrite, so I'm calling this 3.0.
Hopefully that explains the version.

Copyright
---------

Copyright (c) 2010 chrisrhoden. See LICENSE for details.
