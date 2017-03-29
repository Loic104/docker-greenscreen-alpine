const cradle = require('cradle')
const config = require('./config').couch

const couch = new cradle.Connection(config.host, config.port, { auth: { username: 'gscreen', password: 'gscreen' } })
const db = couch.database(config.db)

console.log('Ensuring DB Exists...')

db.exists(function (err, exists) {
  if (err) {
    console.log('error', err)
  } else if (exists) {
    console.log('the force is with you.')
  } else {
    console.log('database does not exists.')
    db.create(function (err2) {
      console.log('error', err2)
    })
    /* populate design documents */
    console.log('Creating Design Doc...')
  }
})
