import React, { useState } from 'react'
import { withRouter } from 'react-router-dom'
import { Paper, Typography, TextField, FormControl, Button } from '@material-ui/core'

import '../style/login.scss'
import API from '../api/Api.js'


const Login = ({ history }) => {
  const [id, setId] = useState('')
  const [password, setPassword] = useState('')

  const handleSignIn = async () => {
    try {
      const { data } = await API.signIn({
        id,
        password
      })

      window.localStorage.setItem('userInfo', JSON.stringify(data))
      window.localStorage.setItem('userId', data.id)
      window.localStorage.setItem('token', data.token)
      window.localStorage.setItem('type', data.type)
      //2021.04.20 add for authority
      window.localStorage.setItem('authority', data.authority)

      window.location.href = '/'
    } catch (error) {
      alert('아이디 또는 비밀번호가 일치하지않습니다')
    }
  }

  return (
    <div className="login-screen">
      <div className="login-panel">
        <Paper>
          <Typography variant="h5" component="h3" gutterBottom>
            로그인
          </Typography>

          <FormControl fullWidth margin="dense">
            <TextField label="아이디" variant="outlined" value={id} onChange={e => setId(e.target.value)} />
          </FormControl>

          <FormControl fullWidth margin="dense">
            <TextField label="비밀번호" type="password" variant="outlined" value={password} onChange={e => setPassword(e.target.value)} />
          </FormControl>

          <FormControl fullWidth margin="normal">
            <Button color="primary" variant="contained" size="large" onClick={handleSignIn} fullWidth>로그인</Button>
          </FormControl>
        </Paper>
      </div>
    </div>
  )
}

export default withRouter(Login)
