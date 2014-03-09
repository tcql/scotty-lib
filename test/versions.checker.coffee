chai = require('chai')
chai.should()

{checker} = require '../src/versions/checker'

describe 'Version checker Instance', ->

    it 'should be instantiable', ->
        v = new checker

    it 'should be able to get latest version', ->
        v = new checker
        v.latest_version = '1.6.0'
        v.getLatest().should.equal '1.6.0'

    it 'should return true if latest installed is the latest version', ->
        v = new checker
        v.latest_version = '1.6.0'
        v.latest_installed = '1.6.0'
        v.isLatestInstalled().should.equal true

    it 'should return false if latest installed is not the latest version', ->
        v = new checker
        v.latest_version = '1.6.0'
        v.latest_installed = '1.5.0'
        v.isLatestInstalled().should.equal false

    it 'should clean malformed versions', ->
        v = new checker
        v.cleanVersion('1.6.0').should.equal '1.6.0'
        v.cleanVersion('v1.6.0').should.equal '1.6.0'
        v.cleanVersion('1.6').should.equal '1.6.0'
        v.cleanVersion('1').should.equal '1.0.0'

    it 'should throw error if we try to clean invalid versions', ->
        v = new checker
        (-> v.cleanVersion('')).should.throw Error
        (-> v.cleanVersion('1.1.1.1')).should.throw Error

