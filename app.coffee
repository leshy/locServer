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
express = require 'express'
ejs = require 'ejs'
ejslocals = require 'ejs-locals'

collections = require 'collections/serverside'
remotecollections = require 'collections-remote/serverside'


settings =
    httpport: 3335
    viewsFolder: __dirname + '/views'
    staticFolder: __dirname + '/static'

env = { settings: settings }

initDb = (callback) ->
    env.db = new mongodb.Db 'loclog', new mongodb.Server('localhost', 27017), safe: true
    env.db.open callback

initCollections = (callback) ->
    env.points = new collections.MongoCollection db: env.db, collection: 'points'
    env.point = env.points.defineModel 'point', {}
    callback()

initExpress = (callback) ->
    env.app = app = express()

    app.configure ->
        app.engine 'ejs', ejslocals
        app.set 'view engine', 'ejs'
        app.set 'views', settings.viewsFolder

        app.use express.static(settings.staticFolder, { maxAge: 18000 })
        app.use express.bodyParser()
        app.use express.logger('dev')    
        app.use app.router
        app.use (err, req, res, next) ->
            console.log err.stack
            console.log  'web request error', err.stack 
            res.render 'error', { errorcode: 500, errordescription: 'Internal Server Error', title: '500'}

        env.server = http.createServer env.app
        env.server.listen settings.httpport
        console.log 'http server listening'
        callback undefined, true

initRoutes = (callback) ->    
    env.app.get '/api/v1/loc', (req,res) ->
        env.points.findModels {}, {sort: { time: -1 }, limit: 1}, (err,data) ->
            res.send data.attributes
            
    env.app.get '/', (req,res) ->
        res.render('index.ejs')

blab = (callback) ->
    env.points.findModels {}, {sort: { time: -1 }, limit: 1}, ((err,data) ->
        console.log err,data.attributes), callback

init = (callback) ->
    async.auto
        db: initDb
        express: initExpress
        routes: [ 'express', initRoutes ]
        collections: [ 'db', initCollections ]
        blab: [ 'collections', blab ]

    
init (err,data) ->
    if not err
        console.log 'done!'
    else
        console.log 'fail!'
