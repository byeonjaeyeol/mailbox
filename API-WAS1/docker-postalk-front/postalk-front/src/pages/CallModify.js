import React, { useState } from 'react'

import API from '../api/Api'
import useInputs from '../hooks/useInputs'
import { withRouter } from 'react-router-dom'

import { Card, CardContent, Grid, Box, Button, TextField, MenuItem } from '@material-ui/core'
import DefaultTemplate from '../components/template/DefaultTemplate'


const CallModify = ({ history, match }) => {
  const { id } = match.params

  const [state, onChange, dispatch] = useInputs({
    class: 0,
    subject: '',
    content: ''
  })

  const classValues = [
    { text: '기능요청', value: 0 },
    { text: '버그 및 수정요청', value: 1 },
    { text: '장애', value: 2 },
  ]


  const init = async () => {
    const [data] = await API.getCall(id)

    dispatch({
      type: 'initial',
      state: Object.keys(state).reduce((acc, key) => (
        { ...acc, [key]: data[key] === null ? '' : data[key] }
      ), {})
    })
  }

  const handleModify = async () => {
    if (!Object.keys(state).every(key => key === 'class' || state[key].trim().length > 0)) {
      return alert('모두 입력해주세요')
    }

    const form = new FormData()

    Object.keys({ ...state }).forEach(key => {
      form.append(key, state[key])
    })

    const response = await API.modifyCall(id, { ...state })

    if (response.status === 200) {
      alert('콜이 수정되었습니다.')
      history.replace(`/call`)
    } else {
      alert('콜 수정에 실패했습니다.')
    }
  }

  const handleDelete = async () => {
    const response = await API.deleteCall(id)

    if (response.status === 200) {
      alert('콜이 삭제되었습니다.')
      history.replace(`/call`)
    } else {
      alert('콜 삭제에 실패했습니다.')
    }
  }

  const handleGoBack = () => {
    history.replace(`/call`)
  }

  React.useEffect(() => {
    init()
  }, [])


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

            <Grid item xs={12}>
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

            <Grid item xs={12}>
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
            </Grid>

          </Grid>
        </CardContent>
      </Card>
    </DefaultTemplate>
  )
}

export default withRouter(CallModify)
