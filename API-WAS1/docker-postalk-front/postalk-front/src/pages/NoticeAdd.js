import React, { useState, useRef } from 'react'

import API from '../api/Api'
import useInputs from '../hooks/useInputs'
import { withRouter } from 'react-router-dom';

import { Card, CardContent, Typography, Grid, Box, Button, InputBase, IconButton, TextField } from '@material-ui/core';
import Input from '../components/input/Input'
import Editor from '../components/editor/Editor'
import DefaultTemplate from '../components/template/DefaultTemplate'
import CloudUpload from '@material-ui/icons/Search';

const NoticeAdd = ({ history }) => {
  const [file, setFile] = useState(null)
  const editorRef = useRef()
  const { manager: userName } = window.localStorage.getItem('userInfo') ? JSON.parse(window.localStorage.getItem('userInfo')) : {}

  const [state, onChange] = useInputs({
    subject: '',
    content: '',
    reg_name: userName
  })

  const handleAdd = async () => {
    if (!(state.subject.length > 0)) {
      return alert('제목을 입력해주세요')
    }
    
    const form = new FormData()

    form.append('subject', state.subject)
    form.append('content', editorRef.current.innerHTML)
    form.append('reg_name', state.reg_name)
    // form.set('file', file)

    const response = await API.addNotice(form)

    if (response.status === 200) {
      alert('공지사항이 등록되었습니다.')
      history.push(`/notice`)
    } else {
      alert('공지사항 등록에 실패했습니다.')
    }
  }

  return (
    <DefaultTemplate>
      <Card>
        <CardContent>
          <Grid container spacing={1}>
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
              {/* <TextField
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
              /> */}
              <Editor ref={editorRef} />
            </Grid>

            {/* <Grid item xs={12}>
              <TextField
                label="파일첨부"
                name="file"
                type="file"
                onChange={e => setFile(e.target.files[0])}
                variant="outlined"
                margin="normal"
                InputLabelProps={{ shrink: true }}
                fullWidth
              />
            </Grid> */}

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

export default withRouter(NoticeAdd)
