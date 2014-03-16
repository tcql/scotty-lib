    fs = require 'fs-extra'


File
========
The File class is a utility class for scotty which supports reading and writing json files
including an intermediary data object for quick modification and reading.

    class exports.file

File is initialized with a path to json file to be read from / written to.

        constructor: (@filepath)->


Reading
-------

        read: (force = false)->

If the json file does not exist, it will be created before it can be read.

            if not fs.existsSync(@filepath)
                @write()

The json file will not be written unless either the `@filedata` has been altered or we `force` writing

            if force or not @filedata
                @filedata = fs.readJsonSync(@filepath)

            return @filedata

Writing
-------

        write: ()->

If there is no data to be written to the file, it will be populated by a default data object,
set by `setInitialFileData` before the json file will be written.

            if not @filedata
                @setInitialFileData()

            fs.outputJsonSync(@filepath, @filedata)

Classes which extend the File class will typically reimplement `setInitialFileData()` to provide
a starting structure for the json file.

        setInitialFileData: ()->
            @filedata = {}

Manipulating the filedata
-------------------------

The entirety of the file data can be retrieved using `getData()`

        getData: ()->
            return @filedata

It can also be set using `setData(data)`

        setData: (data)->
            @filedata = data

Since filedata is an object, sometimes it is useful to more retrieve properties out of the file.
For example, when dealing with the `versions.json` file, `get("installed")` will retrieve the list of
installed versions from the file data

        get: (property)->
            return @filedata[property]

Likewise, filedata can be reset using `set(property, value)`

        set: (property, value)->
            @filedata[property] = value


