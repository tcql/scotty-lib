    async   = require('async')

Storage
=======
The Storage class is an abstraction layer over the NeDB that handles storing version data.
This will make it easier to replace NeDB if at some point in the future a better utility
is found.

    class exports.storage


Dealing with versions
---------------------
Version data needs to be synced on disk so that we can

1. Track what versions are available
1. More importantly, keep track of which versions we've installed locally

To facilitate this, Storage uses [NeDB](https://github.com/louischatriot/nedb).
NeDB can store arbitrary objects, and supports automatic disk syncing.


During initialization, Storage receives an instance an NeDB and an instance of
the Scotty versions Checker.

        constructor: (@db, @checker)->


Keeping up to date
------------------
The key purpose of Storage is to abstract the NeDB queries going on under the hood, so any external
consumers of the Scotty versions library don't need to know how to use NeDB.


#### Syncing

        syncVersionList: (versions, callback = ->)->
            async.map versions, @_insertNew.bind(@), (err, results)=>
                callback(versions, err, results)

allows consumers to update the list of available phaser versions. Storage will intelligently handle
these by only inserting new versions it doesn't already know aboout (see `_insertNew`).

#### Installing

        install:(version, callback = ->)->
            @db.update {name: version}, { $set: {installed: true, in_progress: false } }, callback

allows us to mark versions as installed.


#### Getting a version

        get: (version, callback = ->)->
            @db.findOne {name: version}, callback

allows us to find a version by name.


#### Get installed version s

        getInstalled: (callback = ->)->
            @db.find({"installed": true}).sort({name: -1}).exec callback

allows us to find only the installed versions.


#### Getting all versions

        getAll: (callback = ->)->
            @db.find({}).sort({name: -1}).exec callback

allows us to get a list of every available version.


#### Getting only the latest version

        getLatest: (callback = ->)->
            @db.find {}, (err, docs)=>
                vers = []
                vers.push(ver.clean) for ver in docs

                max = @checker.getLatest(vers)

                @db.findOne {clean: max}, callback

allows us to get the most recent version. This is handled by using `@checker`, an instance of Scotty Versions Checker
which uses semver to compare version numbers.


#### Checking if a version is installed

        isInstalled: (name, callback = ->)->
            @db.count {name: name, installed: true}, (err, count)=>
                if count > 0
                    callback(true)
                else
                    callback(false)

allows us to find out if a version has been installed locally or not.


#### Setting In progress

When  a version download is started, the record should be marked
as in progress

        setInProgress: (version, callback = -> )->
            @db.update {name: version}, { $set: {in_progress: true } }, callback


        setNoneInProgress:(callback = -> )->
            @db.update {}, { $set: {in_progress: false}}, {multi: true}, callback


#### Internal methods

        _insertNew:(version, callback)=>
            self = @
            @db.findOne {name: version.name}, (err, doc)->
                if not doc?
                    record = self._formatRecord(version)
                    self.db.insert record, (err)->
                        callback(err, record)
                else
                    callback(null, null)


        _formatRecord: (version)=>
            return {
                name: version.name,
                installed: false,
                url: version.url,
                clean: @checker.cleanVersion(version.name)
                in_progress: false
            }
