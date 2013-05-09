# Installation
1. Install nodejs and npm
1. Create a `git clone git://github.com/Luzifer/node-hikechat.git`
1. Get into your clone and execute `npm install` to install depencies

# Usage
1. Get a rooted Android device with your chat messages stored in hike
1. Get a copy of the folder `/data/data/com.bsb.hike/databases`
1. Sync that copy into the `database` folder in your clone
1. Execute `./hike.coffee` to get an overview of your chats
1. Execute `./hike.coffee <conversation id>` to get a dump of that conversation to the console
1. Store the dump using for example `./hike.coffee 4 > /tmp/mychat.txt`

# Parameters
    Usage: ./hike.coffee [OPTIONS] [conversation ID]
    
      -h, --help                 displays this help
      -n, --name=DISPLAYNAME     set DISPLAYNAME instead of "me" in output
      -p, --partner=DISPLAYNAME  set DISPLAYNAME instead of contacts name in output
          --no-files             strip out files from chat log

# ToDo
- Find out about groupchats and handle them correctly in export

# License
    Copyright (c) 2013 Knut Ahlers <knut@ahlers.me>
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
