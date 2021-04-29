import React, { useState, useEffect } from 'react'
import { format } from 'date-fns'

import API from '../api/Api'

import { withRouter } from 'react-router-dom'
import { IconButton } from '@material-ui/core'
import { Add } from '@material-ui/icons'
import DefaultTemplate from '../components/template/DefaultTemplate'
import Table from '../components/table/Table'


const Format = ({ history }) => {
  const [data, setData] = useState([])

  const columns = [
    {
      field: 'template_name',
      title: '서식 이름'
    },
    {
      field: 'template_code',
      title: '서식 코드'
    },
    {
      field: 'file_name',
      title: '파일 이름'
    },
    {
      field: 'org_name',
      title: '기관명',
    }
  ]

  const init = async () => {
    const res = await API.getFormats()

    setData(res)
  }

  useEffect(() => {
    init()
  }, [])

  const handleAddButton = () => {
    history.push(`/format/add`)

    return false
  }

  const FormatAddButton = () => {
    return (
      <IconButton onClick={handleAddButton}>
        <Add></Add>
      </IconButton>
    )
  }

  const handleRowClick = (e, rowData) => {
    history.push(`/format/modify/${rowData.idx}`)

    return false
  }

  return (
    <DefaultTemplate>
      <Table
        title="서식 목록"
        columns={columns}
        data={data}
        onRowClick={handleRowClick}
        isAddToolbar={true}
        AddToolbar={FormatAddButton}
        options={{
          filtering: true,
          exportButton: true
        }}
      />
    </DefaultTemplate>
  )
}

export default withRouter(Format)