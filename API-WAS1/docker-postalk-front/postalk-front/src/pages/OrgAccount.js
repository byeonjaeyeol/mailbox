import React, { useState, useEffect } from 'react'

import API from '../api/Api'
import { withRouter } from 'react-router-dom';

import DefaultTemplate from '../components/template/DefaultTemplate'
import Table from '../components/table/Table'
import OrgAccountDialog from '../components/dialog/OrgAccountDialog'


const OrgAccount = ({ history }) => {
  const [data, setData] = useState([])

  const columns = [
    {
      field: 'org_name',
      title: '기관'
    },
    {
      field: 'dept_name',
      title: '부서'
    },
    {
      field: 'user',
      title: '계정'
    },
    {
      field: 'manager',
      title: '담당자 이름'
    },
    {
      field: 'contact',
      title: '담당자 연락처'
    },
    {
      field: 'email',
      title: '담당자 이메일'
    },
    {
      field: 'authority',
      title: '권한'
    }
  ]

  const init = async () => {
    const res = await API.getAccounts('org')

    setData(res)
  }

  useEffect(() => {
    init()
  }, [])

  const handleRowClick = (e, rowData) => {
    history.push(`/org/account/modify/${rowData.id}`)

    return false
  }

  return (
    <DefaultTemplate>
      <Table
        title="발송기관 계정 관리"
        columns={columns}
        data={data}
        onRowClick={handleRowClick}
        isAddToolbar={true}
        AddToolbar={OrgAccountDialog}
        AddToolbarProps={{ init }}
        options={{
          filtering: true,
          exportButton: true
        }}
      />
    </DefaultTemplate>
  )
}

export default withRouter(OrgAccount)