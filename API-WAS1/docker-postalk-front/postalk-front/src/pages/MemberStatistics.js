import React, { useState, useEffect } from 'react'

import API from '../api/Api'
import moment from 'moment'

import DefaultTemplate from '../components/template/DefaultTemplate'
import Table from '../components/table/Table'

const MemberStatistics = () => {
  const [state, setState] = useState({
    start: (new moment()).subtract(3, 'months').format('YYYY-MM-DD'),
    end: (new moment()).format('YYYY-MM-DD')
  })
  const [data, setData] = useState([])

  const columns = [
    {
      field: 'date',
      title: '일자'
    },
    {
      field: 'join',
      title: '가입회원수',
      filtering: false

    },
    {
      field: 'exit',
      title: '탈퇴회원수',
      filtering: false

    },
    {
      field: 'guest',
      title: '비회원가입수',
      filtering: false

    },
  ]

  const init = async () => {
    const start = (new moment(state.start)).format('YYYY-MM-DD')
    const end = (new moment(state.end)).format('YYYY-MM-DD')

    if (String(start).toLowerCase() == 'invalid date' || String(end).toLowerCase() == 'invalid date') {
      return false
    }

    const res = await API.getMemberStatistics({
      startDate: start,
      endDate: end
    })

    setData(res)
  }

  useEffect(() => {
    init()
  }, [state])

  return (
    <DefaultTemplate>
      <Table
        term
        termStart={state.start}
        termColumn="date"
        useTermDiffValidate
        title="회원 통계"
        columns={columns}
        data={data}
        date={state}
        setDate={setState}
        options={{
          filtering: true,
          exportButton: true
        }}
      />
    </DefaultTemplate>
  )
}

export default MemberStatistics