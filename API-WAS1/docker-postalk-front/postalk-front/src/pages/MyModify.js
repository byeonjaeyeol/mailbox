import React from 'react'
import produce from 'immer'
import { Card, CardContent, Typography, Grid, Box, Button, InputBase, IconButton, TextField } from '@material-ui/core';

import API from '../api/Api'
import DefaultTemplate from '../components/template/DefaultTemplate'

const MyModify = () => {
  const [state, setState] = React.useState({
    manager: '',
    contact: '',
    email: ''
  })
  const type = localStorage.getItem('type')
  const userId = localStorage.getItem('userId')

  const init = async () => {

    const res = (await API.getAccount(type, userId))[0]

    setState(produce(v => {
      v.manager = res.manager
      v.contact = res.contact
      v.email = res.email
    }))
  }

  const save = async () => {


    const res = await API.myModify(userId, type, {
      manager: state.manager,
      contact: state.contact,
      email: state.email
    })
    
    alert('변경이 완료되었습니다.')
  }

  const changeVal = (type, val) => {
    setState(produce(v => {
      v[type] = val
    }))
  }

  React.useEffect(() => {
    init()
  }, [])

  return (
    <DefaultTemplate>
      <Card>
        <CardContent>
          <Grid container spacing={1}>
            <Grid item xs={12}>
              <TextField
                type="text"
                label="담당자 이름"
                name="manager"
                value={state.manager}
                variant="outlined"
                margin="normal"
                onChange={(e) => changeVal('manager', e.target.value)}
                fullWidth
              />
            </Grid>

            <Grid item xs={12}>
              <TextField
                type="text"
                label="담당자 연락처"
                name="contact"
                value={state.contact}
                variant="outlined"
                margin="normal"
                onChange={(e) => changeVal('contact', e.target.value)}
                fullWidth
              />
            </Grid>

            <Grid item xs={12}>
              <TextField
                type="text"
                label="담당자 이메일"
                name="email"
                value={state.email}
                variant="outlined"
                margin="normal"
                onChange={(e) => changeVal('email', e.target.value)}
                fullWidth
              />
            </Grid>

            <Grid item xs={12}>
              <Box width={1} display="flex" justifyContent="flex-end">
                <Button
                  variant="outlined"
                  color="primary"
                  onClick={save}
                >변경하기</Button>
              </Box>
            </Grid>
          </Grid>
        </CardContent>
      </Card>
    </DefaultTemplate>
  )
}

export default MyModify