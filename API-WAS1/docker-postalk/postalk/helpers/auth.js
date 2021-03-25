const jwt = require('jsonwebtoken')
const { secret } = require('../configs/jwt')

const sign = data => jwt.sign(data, secret)

const verify = token => {
  try {
    return jwt.verify(token, secret)
  } catch (error) {
    return null
  }
}

module.exports = {
  sign,
  verify
}