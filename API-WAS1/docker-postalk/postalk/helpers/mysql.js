const mysql = require('mysql')
const fs = require('fs')
const config = require('../configs/db')

const pool = mysql.createPool(config)

const getConnection = new Promise((res, rej) => {
  pool.getConnection(function (err, connection) {
    err ? rej(err) : res(connection)
  })
})

const query = (connection, sql, values) => new Promise((res, rej) => {
  connection.query({ sql, values }, (err, results) => {
    err ? rej(err) : res(results)
  })
})

const connect = async (fn) => {
  const connection = await getConnection()
  await fn(async (sql, values) => await query(connection, sql, values))
  connection.release()
}

const oneQuery = async (sql, values) => await query(pool, sql, values)

const file = {
  async get(id) {
    return (await oneQuery('SELECT * FROM TBL_FILES WHERE id = ?', [id]))[0]
  },

  async insert(data) {
    const { insertId } = await oneQuery('INSERT INTO TBL_FILES SET ?', {
      filename: data.filename,
      origin_filename: data.originalname
    })

    return insertId
  },

  async delete(id) {
    const row = await this.get(id)

    if (row) {
      fs.unlinkSync(`${global.uploadDir}/${row.filename}`)
      await oneQuery('DELETE FROM TBL_FILES WHERE id = ?', [id])
    }
  }
}

module.exports = {
  connect,
  oneQuery,
  file
}