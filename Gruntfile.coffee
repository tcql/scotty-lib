module.exports = (grunt)->

    grunt.initConfig
        coffee:
            scotty:
                expand: true,
                flatten: false,
                cwd: 'src/',
                src: ['**/*.coffee','**/*.litcoffee'],
                dest: 'build',
                ext: '.js'
        pkg: grunt.file.readJSON('package.json'),
        uglify:
            options:
                compress:
                    drop_console: true
            scotty:
                options:
                    mangle: false
                    banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
                        '<%= grunt.template.today("yyyy-mm-dd") %> */\n'
                files: [{
                    expand: true,
                    cwd: 'build/',
                    src: '**/*.js',
                    dest: 'build/'
                }]



    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-coffee');


    grunt.registerTask "scotty:build", ["coffee", "uglify"]
