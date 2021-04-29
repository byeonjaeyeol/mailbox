import React, { useState, useRef } from 'react'

import API from '../api/Api'
import useInputs from '../hooks/useInputs'
import { withRouter } from 'react-router-dom'

import { Card, CardContent, Grid, Box, Button, TextField } from '@material-ui/core'
import DefaultTemplate from '../components/template/DefaultTemplate'
import Editor from '../components/editor/Editor'


const NoticeModify = ({ history, match }) => {
  const { id } = match.params
  const editorRef = useRef()
  const [file, setFile] = useState(null)
  const [state, onChange, dispatch] = useInputs({
    subject: '',
    content: ''
  })

  const init = async () => {
    const [ data ] = await API.getNotice(id)
    
    dispatch({
      type: 'initial',
      state: Object.keys(state).reduce((acc, key) => (
        { ...acc, [key]: data[key] || '' }
      ), {})
    })
  }

  const handleModify = async () => {
    if (!(state.subject.length > 0)) {
      return alert('제목을 입력해주세요')
    }

    const form = new FormData()

    form.append('subject', state.subject)
    form.append('content', editorRef.current.innerHTML)

    // form.set('file', file)

    const response = await API.modifyNotice(id, form)
    
    if (response.status === 200) {
      alert('공지사항이 수정되었습니다.')
      history.replace(`/notice`)
    } else {
      alert('공지사항 수정에 실패했습니다.')
    }
  }

  const handleDelete = async () => {
    const response = await API.deleteNotice(id)

    if (response.status === 200) {
      alert('공지사항이 삭제되었습니다.')
      history.replace(`/notice`)
    } else {
      alert('공지사항 삭제에 실패했습니다.')
    }
  }

  const handleGoBack = () => {
    history.replace(`/notice`)
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
              {state.content ? (
                <Editor ref={editorRef} content={state.content} />
              ) : ''}
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

export default withRouter(NoticeModify)
