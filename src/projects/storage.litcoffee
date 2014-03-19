

    class exports.storage

        constructor: (@db)->


        getAll: (callback = ->)->
            @db.find {}, callback


        getByName: (name, callback = ->)->
            @db.findOne {name: name}, callback

        getById: (id, callback = ->)->
            @db.findOne {_id: id}, callback

        getBy: (query = {}, callback = ->)->
            @db.findOne query, callback


        nameInUse: (name, callback)->
            @db.count {name: name}, (err, count)=>
                if count > 0
                    callback(true)
                else
                    callback(false)


        add: (project, callback = ->)->
            @db.insert project, callback

        update: (project, callback = ->)->
            id = project._id
            delete project["_id"]

            @db.update {_id: id }, { $set: project}, {}, callback


        deleteById: (id, callback = ->)->
            @db.remove { _id: id }, {}, callback
