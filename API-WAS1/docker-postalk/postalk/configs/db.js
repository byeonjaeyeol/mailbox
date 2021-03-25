const config = {
  host: 'emailbox',
  user: 'embuser',
  port: '3306',
  password: '!tilon9099@',
  database: 'EMAILBOX',
  connectionLimit: 30
}

if (process.env.NODE_ENV === 'dev') {
  config.host = 'emailbox'
  config.port = '3306'
}

module.exports = config
