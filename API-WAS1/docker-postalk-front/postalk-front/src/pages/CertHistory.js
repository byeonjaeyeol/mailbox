import React, { useEffect, useState } from 'react'
import { format } from 'date-fns'
import { Box, Paper, Button, Dialog } from '@material-ui/core'
import moment from 'moment'

import '../components/queryTrace/queryTrace.scss'
import API from '../api/Api'

import Table from '../components/table/Table'
import DefaultTemplate from '../components/template/DefaultTemplate'
import StartEndDatePicker from '../components/datePicker/StartEndDatePicker'


const PostingLookup = () => {
  const signUserType = localStorage.getItem('type')
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
      field: 'issue_datetime',
      title: '발급일시',
      render: rowData => format(new Date(rowData.issue_datetime), 'yyyy-MM-dd HH:mm:dd')
    },
    {
      field: 'issue_number',
      title: '발급번호'
    },
    {
      field: 'from_name',
      title: '송신자-이름',
    },
    {
      field: 'from_license_num',
      title: '송신자-식별번호(사업자등록번호)'
    },
    {
      field: 'to_name',
      title: '수신자-이름'
    },
    {
      field: 'to_pi',
      title: '수신자-PI값'
    },
    {
      field: 'send_date',
      title: '송신날짜'
    },
    {
      field: 'recv_date',
      title: '수신날짜',
    },
    {
      field: 'read_date',
      title: '열람일자'
    },
    {
      field: 'doc_title',
      title: '문서제목'
    },
    {
      field: 'doc_hash',
      title: '본문정보값'
    },
    {
      field: 'issue_date',
      title: '증명서 발급일시(최초발급일자)'
    }
  ]

  const init = async () => {
    const res = await API.getCertHistory()

    setData(res)
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
        scrollable
        useTermDiffValidate
        termColumn="issue_datetime"
        title="수발신 증명서 발급 이력"
        columns={columns}
        data={data/* .filter(v => {
          let vDate = format(new Date(v.issue_datetime), 'yyyy-MM-dd')
          let start = format(filter.start, 'yyyy-MM-dd')
          let end = format(filter.end, 'yyyy-MM-dd')

          return start <= vDate && vDate <= end
        }) */}
        options={{
          filtering: true,
          exportButton: true
        }}
      />
    </DefaultTemplate>
  )
}

export default PostingLookup