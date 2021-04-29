import React, { useState, useEffect } from 'react'
import { format } from 'date-fns'
import moment from 'moment'

import API from '../api/Api'

import { withRouter } from 'react-router-dom';
import { IconButton } from '@material-ui/core';
import { Add } from '@material-ui/icons'
import DefaultTemplate from '../components/template/DefaultTemplate'
import Table from '../components/table/Table'


const Call = ({ history }) => {
  const [data, setData] = useState([])

  const columns = [
    {
      field: 'class',
      title: '구분'
    },
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

  const classValues = [
    { text: '기능요청', value: 0 },
    { text: '버그 및 수정요청', value: 1 },
    { text: '장애', value: 2 },
  ]

  const init = async () => {
    const res = await API.getCalls()

    setData(res.map(x => ({
      ...x,
      class: classValues.find(v => v.value === x.class).text,
      reg_dt: format(new Date(x.reg_dt), 'yyyy-MM-dd HH:mm:dd')
    })))
  }

  useEffect(() => {
    init()
  }, [])

  const handleAddButton = () => {
    history.push(`/call/add`)

    return false
  }

  const CallAddButton = () => {
    return (
      <IconButton onClick={handleAddButton}>
        <Add></Add>
      </IconButton>
    )
  }

  const handleRowClick = (e, rowData) => {
    history.push(`/call/modify/${rowData.id}`)

    return false
  }

  return (
    <DefaultTemplate>
      <Table
        term
        termStart={(new moment()).subtract(3, 'months').format('YYYY-MM-DD')}
        termColumn="reg_dt"
        useTermDiffValidate
        title="민원 관리"
        columns={columns}
        onRowClick={handleRowClick}
        data={data}
        isAddToolbar={true}
        AddToolbar={CallAddButton}
        options={{
          filtering: true,
          exportButton: true
        }}
      />
    </DefaultTemplate>
  )
}

export default withRouter(Call)