chai = require('chai')
chai.should()

{checker} = require '../src/versions/checker'

describe 'Version checker Instance', ->

    it 'should be instantiable', ->
        v = new checker

    it 'should be able to get latest version', ->
        v = new checker

        v.getLatest(['1.1.5','1.1.6','1.0.0']).should.equal '1.1.6'

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

