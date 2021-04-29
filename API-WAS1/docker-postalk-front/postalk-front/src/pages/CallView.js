import React, { useEffect, useState } from 'react'

import API from '../api/Api'

import { Card, CardContent, Typography, Grid, Box, Button, InputBase, IconButton, Tooltip } from '@material-ui/core';
import { withRouter } from 'react-router-dom';
import Input from '../components/input/Input'
import ViewForm from '../components/viewForm/ViewForm'
import DefaultTemplate from '../components/template/DefaultTemplate'
import { AttachFile } from '@material-ui/icons';

const CallView = ({ history, match }) => {
  const [state, setState] = useState({
    class: 0,
    subject: '',
    content: '',
    reg_name: '-',
    reg_dt: '',
  })

  const classValues = [
    { text: '기능요청', value: 0 },
    { text: '버그 및 수정요청', value: 1 },
    { text: '장애', value: 2 },
  ]

  const handleGoList = () => {
    history.push(`/call`)

    return false
  }

  const handleDelete = async () => {
    const response = await API.deleteCall(match.params.callId)

    if (response.status === 200) {
      alert('콜이 삭제되었습니다.')

      history.push(`/call`)
    } else {
      alert('콜 삭제를 실패했습니다.')
    }
  }

  const init = async () => {
    const data = await API.getCall(match.params.callId)

    setState(data[0])
  }

  useEffect(() => {
    init()
  }, [])

  return (
    <DefaultTemplate>
      <Card>
        <CardContent>
          <Grid container spacing={1}>
            <Grid item md={12}>
              <Typography variant="h6">
                [{classValues.find(x => x.value === state.class) && classValues.find(x => x.value === state.class).text}] {state.subject}
              </Typography>

              <br />

              <Typography color="textSecondary">
                {state.content}
              </Typography>
            </Grid>
            
            <Grid item xs={12}>
              <Box
                width={1}
                display="flex"
                justifyContent="flex-end"
              >
                <Button
                  variant="outlined"
                  color="secondary"
                  onClick={handleDelete}
                >삭제</Button>
                <Box width={12}></Box>
                <Button
                  onClick={handleGoList}
                  variant="outlined"
                  color="primary"
                >목록</Button>
              </Box>
            </Grid>
          </Grid>
        </CardContent>
      </Card>
    </DefaultTemplate>
  )
}

export default withRouter(CallView)
