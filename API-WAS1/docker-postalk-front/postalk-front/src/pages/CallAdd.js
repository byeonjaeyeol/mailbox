import React from 'react'

import API from '../api/Api'
import useInputs from '../hooks/useInputs'
import { withRouter } from 'react-router-dom';

import { Card, CardContent, Typography, Grid, Box, Button, InputBase, IconButton, TextField, MenuItem } from '@material-ui/core';
import Input from '../components/input/Input'
import DefaultTemplate from '../components/template/DefaultTemplate'
import CloudUpload from '@material-ui/icons/Search';

const CallAdd = ({ history }) => {
  const { manager: userName } = window.localStorage.getItem('userInfo') ? JSON.parse(window.localStorage.getItem('userInfo')) : {}

  const [state, onChange] = useInputs({
    class: 0,
    subject: '',
    content: '',
    reg_name: userName
  })

  const classValues = [
    { text: '기능요청', value: 0 },
    { text: '버그 및 수정요청', value: 1 },
    { text: '장애', value: 2 },
  ]
  

  const handleAdd = async () => {
    if (!Object.keys(state).every(key => key === 'class' || state[key].trim().length > 0)) {
      return alert('모두 입력해주세요')
    }

    const response = await API.addCall(state)

    if (response.status === 200) {
      alert('콜이 등록되었습니다.')
      history.push('/call')
      return false
    } else {
      alert('콜 등록에 실패했습니다.')
    }
  }

  return (
    <DefaultTemplate>
      <Card>
        <CardContent>
          <Grid container spacing={1}>
            <Grid item md={12}>
              <TextField
                label="구분"
                select
                name="class"
                value={state.class}
                onChange={onChange}
                variant="outlined"
                margin="normal"
                fullWidth
              >
                {classValues.map(option => (
                  <MenuItem key={option.value} value={option.value}>
                    {option.text}
                  </MenuItem>
                ))}
              </TextField>
            </Grid>

            <Grid item md={12}>
              <TextField
                label="제목"
                name="subject"
                value={state.subject}
                onChange={onChange}
                variant="outlined"
                margin="normal"
                fullWidth
              />
            </Grid>

            <Grid item md={12}>
              <TextField
                label="내용"
                multiline
                rows={3}
                rowsMax={14}
                name="content"
                value={state.content}
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
                  onClick={handleAdd}
                >확인</Button>
              </Box>
            </Grid>

          </Grid>
        </CardContent>
      </Card>
    </DefaultTemplate>
  )
}

export default withRouter(CallAdd)
