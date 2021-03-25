const crypto = require('crypto')

const encrypt = (password) => new Promise(res => {
  crypto.randomBytes(64, (err, buf) => {
    const salt = buf.toString('base64')

    crypto.pbkdf2(password, salt, 100000, 64, 'sha512', (err, key) => {
      res([key.toString('base64'), salt])
    })
  })
})

const verify = (hash, salt, password) => new Promise(res => {
  crypto.pbkdf2(password, salt, 100000, 64, 'sha512', (err, key) => {
    res(key.toString('base64') === hash)
  })
})

module.exports = {
  encrypt,
  verify
}