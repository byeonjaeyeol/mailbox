import React, { useState } from 'react'

import API from '../api/Api'
import useInputs from '../hooks/useInputs'
import { withRouter } from 'react-router-dom';

import { Card, CardContent, Typography, Grid, Box, Button, InputBase, IconButton, TextField } from '@material-ui/core';
import Input from '../components/input/Input'
import DefaultTemplate from '../components/template/DefaultTemplate'
import CloudUpload from '@material-ui/icons/Search';

const Password = ({ history }) => {
  const userId = localStorage.getItem('userId')

  const [state, onChange] = useInputs({
    nowPassword: '',
    newPassword: '',
    newPassword2: ''
  })

  const handleChangePassword = async () => {
    if (!Object.keys(state).every(key => state[key].trim().length > 0)) {
      return alert('모두 입력해주세요')
    }

    if (state.newPassword !== state.newPassword2) {
      return alert('비밀번호가 일치하지 않습니다')
    }

    try {
      const response = await API.changePassword(userId, state)
  
      if (response.status === 200) {
        alert('비밀번호가 변경되었습니다.')
        history.push(`/`)
      } else {
        alert('기존 비밀번호가 일치하지 않습니다.')
      }
    } catch (error) {
      alert('기존 비밀번호가 일치하지 않습니다.')
    }
  }

  return (
    <DefaultTemplate>
      <Card>
        <CardContent>
          <Grid container spacing={1}>
            <Grid item xs={12}>
              <TextField
                type="password"
                label="현재 비밀번호"
                name="nowPassword"
                value={state.nowPassword}
                onChange={onChange}
                variant="outlined"
                margin="normal"
                fullWidth
              />
            </Grid>

            <Grid item xs={12}>
              <TextField
                type="password"
                label="새 비밀번호"
                name="newPassword"
                value={state.newPassword}
                onChange={onChange}
                variant="outlined"
                margin="normal"
                fullWidth
              />
            </Grid>

            <Grid item xs={12}>
              <TextField
                type="password"
                label="새 비밀번호 확인"
                name="newPassword2"
                value={state.newPassword2}
                onChange={onChange}
                variant="outlined"
                margin="normal"
                fullWidth
              />
            </Grid>

            <Grid item xs={12}>
              <Box width={1} display="flex" justifyContent="flex-end">
                <Button
                  variant="outlined"
                  color="primary"
                  onClick={handleChangePassword}
                >변경하기</Button>
              </Box>
            </Grid>

          </Grid>
        </CardContent>
      </Card>
    </DefaultTemplate>
  )
}

export default withRouter(Password)
