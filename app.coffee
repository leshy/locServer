fs = require 'fs'
_ = require 'underscore'
Backbone = require 'backbone4000'
async = require 'async'
path = require 'path'

helpers = require 'helpers'
decorators = require 'decorators2'
decorate = decorators.decorate

http = require 'http'
mongodb = require 'mongodb'
ejs = require 'ejs'
ejslocals = require 'ejs-locals'

collections = require 'collections/serverside'
remotecollections = require 'collections-remote/serverside'


settings =
    httpport: 3335

env = { settings: settings }

initDb = (callback) ->
    env.db = new mongodb.Db 'loclog', new mongodb.Server('localhost', 27017), safe: true
    env.db.open callback

initCollections = (callback) ->
    env.points = new collections.MongoCollection db: env.db, collection: 'points'
    env.point = env.points.defineModel 'point', {}
    callback()
blab = (callback) ->
    env.points.findModels({}, {sort: { time: -1 }, limit: 1}), ((err,data) -> console.log err,data), callback


init = (callback) ->
    async.auto
        db: initDb
        collections: [ 'db', initCollections ]
        blab: [ 'collections', blab ]

    
init (err,data) ->
    if not err
        console.log 'done!'
    else
        console.log 'fail!'
