semver = require('semver')

class exports.checker
    constructor: ()->


    getLatest: (versions)->
        versions = versions.map (elem)=>
            return @cleanVersion(elem)

        return semver.maxSatisfying(versions, ">0.0.0")

    cleanVersion: (orig_version)->
        version = orig_version.replace /[^0-9\.]/g, ''

        nums = version.split('.')
        nums = nums.filter (elem)->
            return elem isnt ""

        # Yay, a good version
        if nums.length is 3
            return nums.join('.')
        # Missing incremental
        else if nums.length is 2
            return "#{nums[0]}.#{nums[1]}.0"
        # Missing minor
        else if nums.length is 1
            return "#{nums[0]}.0.0"
        # Missing everything, or more than 3 version parts. ERROR
        else
            throw Error("invalid version #{orig_version}")


