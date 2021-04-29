import React, { useState, useEffect } from 'react'

import { withRouter } from 'react-router-dom';
import useInputs from '../hooks/useInputs'
import API from '../api/Api'

import { Card, CardContent, Box, Button, TextField } from '@material-ui/core';
import DefaultTemplate from '../components/template/DefaultTemplate'
import Input from '../components/input/Input'


const SystemAccountModify = ({ history, match }) => {
  const [state, onChange, dispatch] = useInputs({
    user: '',
    password: '',
    manager: '',
    contact: '',
    email: '',
    authority: '',
  })
  const [orgs, setOrgs] = useState([])
  const [depts, setDepts] = useState([])

  const systemAccountModifyForm = [
    { onChange, value: state.user, name: 'user', label: "계정" },
    { onChange, value: state.password, name: 'password', label: "비밀번호", type: 'password' },
    { onChange, value: state.manager, name: 'manager', label: "담당자 이름" },
    { onChange, value: state.contact, name: 'contact', label: "담당자 연락처" },
    { onChange, value: state.email, name: 'email', label: "담당자 이메일" },
    { onChange, value: state.authority, name: 'authority', label: "권한" },
  ]

  const handleGoBack = () => {
    history.push(`/system/account`)

    return false
  }

  const handleModify = async () => {
    const res = await API.modifyAccount('system', state)

    if (res.status === 200) {
      alert('시스템 계정이 수정되었습니다.')

      history.push(`/system/account`)
    } else {
      alert('시스템 계정 수정에 실패했습니다.')

      return false
    }
  }

  const handleDelete = async () => {
    const res = await API.deleteAccount('system', match.params.memberId)

    if (res.status === 200) {
      alert('시스템 계정이 삭제되었습니다.')

      history.push(`/system/account`)
    } else {
      alert('시스템 계정 삭제에 실패했습니다.')

      return false
    }
  }

  const init = async () => {
    const org = await API.getOrgDepts()
    const res = await API.getAccount('system', match.params.memberId)
    
    setOrgs(org.map(x => ({
      text: x.org_name,
      value: x.org_name,
      ...x
    })))
    dispatch({ type: 'initial', state: res[0] })
  }

  useEffect(() => {
    init()
  }, [])

  useEffect(() => {
    if (orgs.length === 0) {
      return () => { }
    }

    const currentOrg = orgs.find(x => x.text === state.org_name)

    if (typeof currentOrg !== 'undefined') {
      setDepts(currentOrg.depts.map(x => ({
        text: x.dept_name,
        value: x.dept_name,
        ...x
      })))
    }
  }, [state.org_name])
  
  return (
    <DefaultTemplate>
      <Card className="systemAccountModify">
        <CardContent>
          <form noValidate autoComplete="off">
            {systemAccountModifyForm.map((input, index) => (
              <div style={{ marginBottom: 24 }}>
                <TextField key={index} {...input} variant="outlined" fullWith />
              </div>
            ))}
          </form>
          <Box
            width={1}
            paddingTop={2}
            display="flex"
            justifyContent="flex-end"
          >
            <Button
              variant="outlined"
              onClick={handleDelete}
              color="primary"
            >삭제</Button>
            <Box width={12}></Box>
            <Button
              variant="outlined"
              color="secondary"
              onClick={handleModify}
            >수정</Button>
            <Box width={12}></Box>
            <Button
              onClick={handleGoBack}
              variant="outlined"
            >취소</Button>
          </Box>
        </CardContent>
      </Card>
    </DefaultTemplate>
  )
}

export default withRouter(SystemAccountModify)
