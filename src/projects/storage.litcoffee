

    class exports.storage

        constructor: (@db)->


        getAll: (callback = ->)->
            @db.find {}, callback


        get: (name, callback = ->)->
            @db.findOne {name: name}, callback


        getBy: (query = {}, callback = ->)->
            @db.findOne query, callback


        nameInUse: (name, callback)->
            @db.count {name: name}, (err, count)=>
                if count > 0
                    callback(true)
                else
                    callback(false)
