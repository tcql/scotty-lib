    fileutil = require('../fileutil').fileutil

Versions File
=============
The File class is for maintaining a metadata json file about phaser versions. This file is
stored by default at `~/.scotty/versions.json`

    class exports.file extends fileutil


The metadata stored includes the `latest` installed version, `available` versions and `installed` versions.
`available` versions are made up of objects that contain both the `name` and `url` of the available
version.

        setInitialFileData: ()->
            @filedata =
                latest: ""
                installed: []
                available: []


The File class also provides a shortcut for finding if a version is installed (as far as the metadata
file knows.

        isInstalled: (version)->
            @read()

            if version in @filedata.installed
                return true

            return false

