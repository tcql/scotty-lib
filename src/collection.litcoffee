Collection
==========


Collection is a utility class for dealing with arbitrary lists of data. It can:

* Get items by attribute (if it is a collection of objects) or by index
* Remove items by value or by index
* Map over items - returns a new collection
* Transform items - edits collection in place
* Filter items - returns a new collection including only items matching the callback

> **Note**: Map will create a deep copy of all objects, using extend

    extend = require('extend')

    class exports.collection


Working with Collection data
----------------------------
To initialize a collection, you may pass an array into the constructor for a new Collection instance or
you can call `setCollection` after the instance has been created. The underlying Collection array is shallow
copied so that external modifications to the source array will not affect the collection, but alterations to
array values that are objects or arrays will affect the same objects in the collection.

        constructor: (collection = [])->
            @setCollection(collection)


        setCollection: (collection)->
            @collection = collection.slice()


The underlying Collection array may be accessed and modified externally.

        getCollection: ()->
            return @collection


Retrieving items
----------------
There are several ways to retrieve items from the Collection.

`get(attr, value)` can be used to retrieve an element by an attribute. For example,
if you have an element in the collection like
```
{"name": "Fred", "age": 12}
```
You could use retrieve it using
```
collection.get("name", "Fred")
```

        get: (attr, value = null)->
            for element in @collection
                v = element[attr] ? element
                if v is value
                    return element

`getAt(index)` can be used to retrieve an element by its index in the underlying Collection array.

        getAt: (index)->
            if @collection[index]?
                return @collection[index]




Removing items
--------------
`remove(item)` can be used to remove an item from the underlying Colection array by passing
in the item you wish to remove. If the item exists more than once in the array, only
the first occurence is removed.

        remove: (item)->
            index = @collection.indexOf(item)

            if index isnt -1
                @collection.splice(index, 1)

`removeAt(index)` can be used to remove at item from the underlying Collection array when
you know it's index in the collection.

        removeAt: (index)->
            if @collection[index]?
                @collection.splice(index, 1)


Manipulating items
------------------
A Collection can manipulate the underlying collection array by using `filter`, `map`, and `transform`.

`filter(filter_function)` can be used to obtain a filtered copy of the collection. The original collection
will not be modified. The `filter_function` is a callback that should receive an element of the array
and return `true` if the element should be kept and `false` if it should be thrown out.

        filter: (filter)->
            results = []

            for i in @collection
                results.push(i) if filter(i) is true

            return new exports.collection(results)

`map(transformer)` can be used to create a copy of the Collection where each element has been altered
by calling the `transformer` on it. Elements will be deep copied before alteration.

        map: (transformer)->
            results = []

            for i in extend(@collection)
                results.push transformer(i)

            return new exports.collection(results)

`transform(transformer)` can be used to alter each element in the Collection by applying the
`transformer` function.

        transform: (transformer)->
            for i,k in @collection
                @collection[k] = transformer(i)
