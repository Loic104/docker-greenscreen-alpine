#!/bin/sh

${COUCH_USER="gscreen"}
${COUCH_PASS="gscreen"}
${COUCH_HOST="http://couchDB"}
${COUCH_PORT="5984"}
${COUCH_DB="gscreen"}

cat > public/js/gscreen-config.js << EOF
angular.module("GScreen").constant('CONFIG',{
  chromecastApplicationId: '$CAST_APPID'
});
EOF

cat > config.json << EOF
{
  "couch": {
    "host": "$COUCH_HOST",
    "port": $COUCH_PORT,
    "db": "$COUCH_DB"
  },
  "server": {
    "port": 4994
  }
}
EOF

cat > src/server/couchdb/index.coffee << EOF
cradle = require "cradle"
views = require "./views"
validations = require "./validations"

module.exports = class CouchDB
  constructor: (config) ->
    @couch = new cradle.Connection config.host, config.port, {auth:{username:"$COUCH_USER", password:"$COUCH_PASS"}}
    @db = @couch.database config.db
    @ensureDbExists =>
      @installDesignDoc()

  ensureDbExists: (cb) ->
    console.log "Ensuring DB Exists..."
    @db.exists (err, exists) =>
      return cb() if exists
      console.log "Creating DB..."
      @db.create cb

  installDesignDoc: (cb) ->
    console.log "Creating Design Doc..."
    @db.save "_design/gscreen",
      views: views
      validate_doc_update: validations

  allWithType: (type, cb) ->
    @db.view "gscreen/byType", key: type, include_docs: true, (err, rows) ->
      return cb(err) if err
      # This next line looks crazy, and it is. Believe it or not, the cradle lib
      # overrides the `map` function to map over the docs, not the rows. This means
      # that the result is an array of docs, rather than an array of rows, which is
      # what we want. Very strange design choice on cradle's part.
      cb(null, rows.map (doc) -> doc)

  get: (args...) -> @db.get(args...)
  save: (args...) -> @db.save(args...)
  remove: (args...) -> @db.remove(args...)



EOF


exec npm start