/*! scotty-lib - v1.0.0 - 2014-03-20 */
(function(){exports.storage=function(){function storage(db){this.db=db}return storage.prototype.getAll=function(callback){return null==callback&&(callback=function(){}),this.db.find({},callback)},storage.prototype.getByName=function(name,callback){return null==callback&&(callback=function(){}),this.db.findOne({name:name},callback)},storage.prototype.getById=function(id,callback){return null==callback&&(callback=function(){}),this.db.findOne({_id:id},callback)},storage.prototype.getBy=function(query,callback){return null==query&&(query={}),null==callback&&(callback=function(){}),this.db.findOne(query,callback)},storage.prototype.nameInUse=function(name,callback){return this.db.count({name:name},function(){return function(err,count){return callback(count>0?!0:!1)}}(this))},storage.prototype.add=function(project,callback){return null==callback&&(callback=function(){}),this.db.insert(project,callback)},storage.prototype.update=function(project,callback){var id;return null==callback&&(callback=function(){}),id=project._id,delete project._id,this.db.update({_id:id},{$set:project},{},callback)},storage.prototype.deleteById=function(id,callback){return null==callback&&(callback=function(){}),this.db.remove({_id:id},{},callback)},storage}()}).call(this);