import React, { useState, useEffect } from 'react'

import API from '../../api/Api'
import useInputs from '../../hooks/useInputs'

import Dialog from './Dialog.js'
import { Grid, IconButton, TextField } from '@material-ui/core'
import { Add } from '@material-ui/icons'
import Input from '../input/Input'

const SystemAccountDialog = ({ init }) => {
  const [state, onChange] = useInputs({
    user: '',
    password: '',
    manager: '',
    contact: '',
    email: '',
    authority: '',
  })
  const [open, setOpen] = useState(false)

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
      alert('이미 사용중인 계정 아이디 입니다')
      return
    }

    const res = await API.addAccount('system', state)

    if (res.status === 200) {
      alert('시스템 계정이 추가되었습니다.')

      init()
      handleClose()
    } else {
      alert('시스템 계정 추가에 실패했습니다.')
    }

  }


  const systemAccountAddForm = [
    { onChange: onChange, value: state.user, name: 'user', label: "계정" },
    { onChange: onChange, value: state.password, name: 'password', label: "비밀번호", type: 'password' },
    { onChange: onChange, value: state.manager, name: 'manager', label: "담당자 이름" },
    { onChange: onChange, value: state.contact, name: 'contact', label: "담당자 연락처" },
    { onChange: onChange, value: state.email, name: 'email', label: "담당자 이메일" },
    { onChange: onChange, value: state.authority, name: 'authority', label: "권한" },
  ]

  return (
    <>
      <IconButton onClick={handleOpen}>
        <Add></Add>
      </IconButton>
      <Dialog
        className="systemAccountDialog"
        open={open}
        onClose={handleClose}
        message={{
          title: '시스템 계정 추가'
        }}
        buttons={[{ onClick: handleAdd, color: 'primary', text: '추가' }]}
      >
        <form noValidate autoComplete="off">
          <Grid container spacing={2}>
            {systemAccountAddForm.map((input, index) => (
              <Grid item xs={6}>
                <Input variant="outlined" key={index} {...input} />
              </Grid>
            ))}
          </Grid>
        </form>
      </Dialog>
    </>
  )
}

export default SystemAccountDialog
