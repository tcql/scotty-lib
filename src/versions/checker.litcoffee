    semver = require('semver')

Version Checker
===============
Checker is a class for checking versions. It handles cleaning version numbers to proper semver
standards, and can tell you if a version is the latest installed version

    class exports.checker

Creating clean semver tags
--------------------------
Unfortunately, the list of versions we retrieve from github (via the `Fetcher` class)
does not contain strictly valid semver tag names. The version checker will clean tags
before doing work any checking on them by

* Stripping non-numeric characters. Dots are retained
* Splitting the version on dots and filling in missing incremental or minor numbers with zeros


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


Checking versions
-----------------
With clean semver tags, we can query the tag list for meaningful information,
such as which tag is the most recent.

        getLatest: (versions)->
            versions = versions.map (elem)=>
                return @cleanVersion(elem)

            return semver.maxSatisfying(versions, ">0.0.0")


        isLatest: (version, versions)->
            return @getLatest(versions) is @cleanVersion(version)

