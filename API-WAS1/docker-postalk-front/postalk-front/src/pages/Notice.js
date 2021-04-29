import React, { useState, useEffect } from 'react'
import { format } from 'date-fns'
import moment from 'moment'

import API from '../api/Api'

import { withRouter } from 'react-router-dom';
import { IconButton } from '@material-ui/core';
import { Add } from '@material-ui/icons'
import DefaultTemplate from '../components/template/DefaultTemplate'
import Table from '../components/table/Table'


const Notice = ({ history }) => {
  const [data, setData] = useState([])

  const columns = [
    {
      field: 'subject',
      title: '제목'
    },
    {
      field: 'reg_dt',
      title: '등록일'
    },
    {
      field: 'reg_name',
      title: '등록자명'
    }
  ]

  const init = async () => {
    const res = await API.getNotices()

    setData(res.map(item => ({
      ...item,
      reg_dt: format(new Date(item.reg_dt), 'yyyy-MM-dd HH:mm:dd')
    })))
  }

  useEffect(() => {
    init()
  }, [])

  const handleAddButton = () => {
    history.push(`/notice/add`)

    return false
  }

  const NoticeAddButton = () => {
    return (
      <IconButton onClick={handleAddButton}>
        <Add></Add>
      </IconButton>
    )
  }

  const handleRowClick = (e, rowData) => {
    history.push(`/notice/modify/${rowData.id}`)

    return false
  }
  

  return (
    <DefaultTemplate>

      <Table
        term
        termStart={(new moment()).subtract(3, 'months').format('YYYY-MM-DD')}
        termColumn="reg_dt"
        useTermDiffValidate
        title="공지사항"
        columns={columns}
        data={data}
        onRowClick={handleRowClick}
        isAddToolbar={true}
        AddToolbar={NoticeAddButton}
        options={{
          filtering: true,
          exportButton: true
        }}
      />
    </DefaultTemplate>
  )
}

export default withRouter(Notice)