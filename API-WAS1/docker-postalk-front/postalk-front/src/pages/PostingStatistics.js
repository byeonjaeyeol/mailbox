import React, { useState, useEffect } from 'react'
import { format } from 'date-fns'
import moment from 'moment'
import { Box, Paper, Button, Dialog } from '@material-ui/core'

import API from '../api/Api'

import DefaultTemplate from '../components/template/DefaultTemplate'
import Table from '../components/table/Table'
import StartEndDatePicker from '../components/datePicker/StartEndDatePicker'


const PostingStatistics = () => {
  const [data, setData] = useState([])
  const [popup, setPopup] = useState(false)
  const [filter, setFilter] = useState({
    org_code: '',
    dept_code: '',
    org_idx: '',
    start: new Date('2019-01-01'),
    end: new Date()
  })


  const columns = [
    {
      field: 'reg_dt',
      title: '접수일'
    },
    {
      field: 'org_name',
      title: '기관명'
    },
    {
      field: 'dept_name',
      title: '부서명'
    },
    {
      field: 'reg_cnt',
      title: '접수물량',
      filtering: false
    },
    {
      field: 'done_dm_cnt',
      title: '종이우편 발송물량',
      filtering: false
    },
    {
      field: 'done_app_cnt',
      title: '모바일우편 발송물량',
      filtering: false
    },
    {
      field: 'done_mms_cnt',
      title: '문자우편 발송물량',
      filtering: false
    },
    {
      field: 'result_mms_fail_cnt',
      title: 'MMS 발송실패 건수',
      filtering: false
    },
    {
      field: 'deny_cnt',
      title: '차단건수',
      filtering: false
    }
  ]

  const init = async () => {
    const res = await API.getPostStatistics()

    setData(res.map(item => ({
      ...item,
      reg_dt: format(new Date(item.reg_dt), 'yyyy-MM-dd')
    })))
  }

  const handleChangeDate = (start, end) => {
    setFilter({
      ...filter,
      start,
      end
    })
  }

  useEffect(() => {
    init()
  }, [])

  return (
    <DefaultTemplate>
      {/* <Box marginY={2}>
        <Paper>
          <Box display="flex" alignItems="center" justifyContent="space-between" padding={2}>
            <Box display="flex" alignItems="center">
            </Box>

            <StartEndDatePicker
              start={filter.start}
              end={filter.end}
              onChange={handleChangeDate}
            />
          </Box>
        </Paper>
      </Box> */}

      <Table
        term={true}
        termStart={(new moment()).subtract(3, 'months').format('YYYY-MM-DD')}
        useTermDiffValidate
        scrollable
        termColumn="reg_dt"
        title="우편물 발송 통계"
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

export default PostingStatistics