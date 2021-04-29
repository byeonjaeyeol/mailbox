import React, { useState, useEffect } from 'react'

import API from '../api/Api'
import { withRouter } from 'react-router-dom'

import { Box } from '@material-ui/core';
import Input from '../components/input/Input'
import Table from '../components/table/Table'
import DefaultTemplate from '../components/template/DefaultTemplate'

const OrgSearchForm = () => {
  return (
    <Box display="flex">
      <Box mr={2}>
        <Input label="업무명" type="text"></Input>
      </Box>
      <Box>
        <Input label="발송담당자" type="text"></Input>
      </Box>
    </Box>
  )
}

const Org = ({ history }) => {
  const [data, setData] = useState([])

  const columns = [
    {
      field: 'org_name',
      title: '기관명'
    },
    {
      field: 'contact',
      title: '담당자 연락처'
    },
    {
      field: 'manager',
      title: '관리자명'
    },
    {
      field: 'license_number',
      title: '사업자 등록번호'
    },
    {
      field: 'stat_trace',
      title: '상태'
    },
  ]
  

  const init = async () => {
    const res = await API.getOrgs()

    setData(res)
  }

  useEffect(() => {
    init()
  }, [])

  const handleRowClick = (e, rowData) => {
    history.push(`/org/modify/${rowData.idx}`)

    return false
  }

  return (
    <DefaultTemplate>
      <Table
        title="발송기관 목록"
        columns={columns}
        data={data}
        onRowClick={handleRowClick}
        options={{
          filtering: true,
          exportButton: true
        }}
        // isAddToolbar={true}
        // AddToolbar={OrgSearchForm}
      />
    </DefaultTemplate>
  )
}

export default withRouter(Org)
