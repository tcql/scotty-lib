chai = require('chai')
chai.should()

{file} = require '../src/versions/file'
fs = require 'fs-extra'


describe 'Version file Instance', ->

    it 'should be instantiable', ->
        f = new file {}

    it 'should write empty versions file', ->
        v = './test/data/empty_versions.json'

        f = new file v
        f.writeFile()

        fs.readJsonSync(v).should.eql {latest: '', installed: []}

        fs.unlinkSync v


    it 'should read a versions file', ->
        v = './test/data/versions.json'

        f = new file v
        f.readFile().should.eql
            "latest": "1.6.0",
            "installed": [
                "1.6.0",
                "1.5.0",
                "1.4.0"
            ]


    it 'should retrieve latest version', ->
        v = './test/data/versions.json'

        f = new file v

        f.getLatestInstalled().should.equal '1.6.0'


    it 'should retrieve all installed versions', ->
        v = './test/data/versions.json'

        f = new file v

        f.getInstalled().should.eql ["1.6.0", "1.5.0", "1.4.0"]


    it 'should update latest version in file', ->
        v = './test/data/empty_versions.json'

        f = new file v

        f.setLatestInstalled("1.7.0")

        fs.readJsonSync(v).should.eql {latest: '1.7.0', installed: []}

        fs.unlinkSync v


    it 'should add versions to installed array', ->
        v = './test/data/empty_versions.json'

        f = new file v

        f.addInstalled("1.7.0")

        fs.readJsonSync(v).should.eql {latest: '', installed: ['1.7.0']}

        fs.unlinkSync v


    it 'should create the file if it doesnt exist when you try reading', ->
        v = './test/data/empty_versions.json'
        fs.existsSync(v).should.equal false

        f = new file v
        f.readFile()

        fs.existsSync(v).should.equal true

        fs.unlinkSync v


    it 'should be able to check if version is installed', ->
        v = './test/data/empty_versions.json'
        fs.existsSync(v).should.equal false

        f = new file v

        f.addInstalled('1.0.0')
        f.addInstalled('1.0.1')

        f.isInstalled('1.0.0').should.equal true
        f.isInstalled('1.0.2').should.equal false

        fs.unlinkSync v
