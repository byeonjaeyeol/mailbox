import React, { useState, useEffect } from 'react'
import { format } from 'date-fns'

import API from '../api/Api'

import DefaultTemplate from '../components/template/DefaultTemplate'
import Table from '../components/table/Table'


const ConnectionSystem = ({ history }) => {
  const [data, setData] = useState([])

  const columns = [
    {
      field: 'user',
      title: '계정'
    },
    {
      field: 'datetime',
      title: '접속일'
    },
    {
      field: 'ip',
      title: 'IP'
    }
  ]

  const init = async () => {
    const { data } = await API.getConnection('system')

    setData(data.map(item => ({
      ...item,
      datetime: format(new Date(item.datetime), 'yyyy-MM-dd HH:mm:dd')
    })))
  }

  useEffect(() => {
    init()
  }, [])


  return (
    <DefaultTemplate>
      <Table
        title="시스템 접속이력"
        columns={columns}
        data={data}
        options={{
          filtering: true,
          exportButton: true
        }}
      />
    </DefaultTemplate>
  )
}

export default ConnectionSystem