/*! scotty-lib - v1.0.0 - 2014-03-20 */
(function(){var fs,request,tar,zlib;request=require("request"),zlib=require("zlib"),tar=require("tar"),fs=require("fs-extra"),exports.examples=function(){function examples(options){this.options=options}return examples.prototype.installed=function(){return fs.existsSync(this.options.examples_path)},examples.prototype.download=function(on_complete){var dest,options,req,url;return null==on_complete&&(on_complete=function(){}),dest=this.options.examples_path,fs.removeSync(dest),url=this.getDownloadUrl(),options={headers:{"User-Agent":"test/1.0"}},req=request(url,options),req.pipe(zlib.createGunzip()).pipe(tar.Extract({path:""+dest,strip:1})),req.on("end",function(){return function(){return on_complete()}}(this))},examples.prototype.getDownloadUrl=function(){return"https://github.com/photonstorm/phaser-examples/archive/master.tar.gz"},examples}()}).call(this);