import React, { useState, useEffect } from 'react'

import API from '../../api/Api'
import useInputs from '../../hooks/useInputs'

import Dialog from './Dialog.js'
import { Box, Grid, IconButton, TextField, MenuItem } from '@material-ui/core'
import { Add } from '@material-ui/icons'
import Input from '../input/Input'

const OrgAccountDialog = ({ init }) => {
  const [state, onChange] = useInputs({
    org_name: '',
    dept_name: '',
    user: '',
    password: '',
    manager: '',
    contact: '',
    email: '',
    authority: '',
  })
  const [orgs, setOrgs] = useState([])
  const [depts, setDepts] = useState([])
  const [open, setOpen] = useState(false)

  const onChangeOrg = (e) => {
    onChange({
      target: {
        name: 'org_name',
        value: e.target.value
      }
    })

    const currentOrg = orgs.find(x => x.text === e.target.value)

    setDepts(currentOrg.depts.map(x => ({
      text: x.dept_name,
      value: x.dept_name,
      ...x
    })))
  }

  const getOrgDept = async () => {
    let org = await API.getOrgDepts()

    setOrgs(org.map(x => ({
      text: x.org_name,
      value: x.org_name,
      ...x
    })))
  }

  useEffect(() => {
    getOrgDept()
  }, [])

  const systemAccountAddForm = [
    { onChange: onChangeOrg, value: state.org_name, name: 'org_name', label: "기관", type: 'select', values: orgs },
    { onChange: onChange, value: state.dept_name, name: 'dept_name', label: "부서", type: 'select', values: depts },
    { onChange: onChange, value: state.user, name: 'user', label: "계정" },
    { onChange: onChange, value: state.password, name: 'password', label: "비밀번호", type: 'password' },
    { onChange: onChange, value: state.manager, name: 'manager', label: "담당자 이름" },
    { onChange: onChange, value: state.contact, name: 'contact', label: "담당자 연락처" },
    { onChange: onChange, value: state.email, name: 'email', label: "담당자 이메일" },
    { onChange: onChange, value: state.authority, name: 'authority', label: "권한" },
  ]

  const handleOpen = () => {
    setOpen(true)
  }

  const handleClose = () => {
    setOpen(false)
  }

  const handleAdd = async () => {
    const valid = Object.keys(state).every(key => state[key].trim().length > 0)

    if (!valid) {
      return alert('모두 입력해주세요')
    }

    const { data: isExist } = await API.existUser(state.user)

    if (isExist) {
      return alert('이미 사용중인 계정 아이디 입니다')
    }

    const res = await API.addAccount('org', state)

    if (res.status === 200) {
      init()
      handleClose()

      alert('발송기관 계정이 추가되었습니다.')
    } else {
      alert('발송기관 계정 추가에 실패했습니다.')
    }
  }

  return (
    <>
      <IconButton onClick={handleOpen}>
        <Add></Add>
      </IconButton>
      <Dialog
        className="orgAccountDialog"
        open={open}
        onClose={handleClose}
        message={{
          title: '발송기관 계정 추가'
        }}
        buttons={[{ onClick: handleAdd, color: 'primary', text: '추가' }]}
      >
        <form noValidate autoComplete="off">
          <Grid container spacing={2}>
            {systemAccountAddForm.map((input, index) => (
              <Grid key={index} item xs={6}>
                {(input.type && input.type === 'select') ? (
                  <TextField
                    label={input.label}
                    name={input.name}
                    select
                    onChange={input.onChange}
                    variant="outlined"
                    fullWidth
                  >
                    {input.values.map(option => (
                      <MenuItem key={option.value} value={option.value}>
                        {option.text}
                      </MenuItem>
                    ))}
                  </TextField>
                ) : (
                  <Input variant="outlined" key={index} {...input} />
                )}
              </Grid>
            ))}
          </Grid>
        </form>
      </Dialog>
    </>
  )
}

export default OrgAccountDialog
