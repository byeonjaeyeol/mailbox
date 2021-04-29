import React, { useState } from 'react'

import API from '../api/Api'
import useInputs from '../hooks/useInputs'
import { withRouter } from 'react-router-dom'

import { Card, CardContent, Grid, Box, Button, TextField, Dialog, DialogTitle, DialogContent, DialogContentText, DialogActions, Checkbox, InputAdornment } from '@material-ui/core'
import DefaultTemplate from '../components/template/DefaultTemplate'


const FormatModify = ({ history, match }) => {
  const { id } = match.params

  const [popup, setPopup] = useState(false)
  const [agencyData, setAgencyData] = useState([])

  const [state, onChange, dispatch] = useInputs({
    agency_id: '',
    template_name: '',
    template_code: '',
    file_name: ''
  })

  const init = async () => {
    const data = await API.getFormat(id)
    const response = await API.getOrgs()

    setAgencyData(response)

    dispatch({
      type: 'initial',
      state: Object.keys(state).reduce((acc, key) => (
        { ...acc, [key]: String(data[key]) || '' }
      ), {})
    })
  }

  const handleModify = async () => {
    if (!Object.keys(state).every(key => state[key].trim().length > 0)) {
      return alert('모두 입력해주세요')
    }

    const response = await API.modifyFormat(id, state)

    if (response.status === 200) {
      alert('서식이 수정되었습니다.')
      history.replace(`/format`)
    } else {
      alert('서식 수정에 실패했습니다.')
    }
  }

  const handleDelete = async () => {
    const response = await API.deleteFormat(id)

    if (response.status === 200) {
      alert('서식이 삭제되었습니다.')
      history.replace(`/format`)
    } else {
      alert('서식 삭제에 실패했습니다.')
    }
  }

  const handleGoBack = () => {
    history.replace(`/format`)
  }

  React.useEffect(() => {
    init()
  }, [])


  return (
    <DefaultTemplate>
      <Card>
        <CardContent>
          <Grid container spacing={1}>
            <Grid item xs={6}>
              <TextField
                label="기관"
                name="agency_id"
                value={state.agency_id}
                onChange={onChange}
                variant="outlined"
                margin="normal"
                InputProps={{
                  endAdornment: (
                    <InputAdornment position="end">
                      <Button variant="contained" color="primary" onClick={() => setPopup(true)}>기관 목록</Button>
                    </InputAdornment>
                  )
                }}
                fullWidth
              />
            </Grid>

            <Grid item xs={6}>
              <TextField
                label="서식이름"
                name="template_name"
                value={state.template_name}
                onChange={onChange}
                variant="outlined"
                margin="normal"
                fullWidth
              />
            </Grid>

            <Grid item xs={6}>
              <TextField
                label="서식코드"
                name="template_code"
                value={state.template_code}
                onChange={onChange}
                variant="outlined"
                margin="normal"
                fullWidth
              />
            </Grid>

            <Grid item xs={6}>
              <TextField
                label="파일이름"
                name="file_name"
                value={state.file_name}
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

      <Dialog open={popup} onClose={() => setPopup(false)} >
        <DialogTitle>기관선택</DialogTitle>

        <DialogContent>
          <DialogContentText>
            조회하실 기관을 선택해주세요. 아무것도 선택 안되있을시 전체가 표시됩니다.
          </DialogContentText>

          <table className="c-table">
            <thead>
              <th>기관 코드</th>
              <th>이름</th>
              <th>부서</th>
              <th>선택</th>
            </thead>

            <tbody>
              {agencyData.map(data => {

                return (
                  <tr key={data.idx}>
                    <td>{data.org_code}</td>
                    <td>{data.org_name}</td>
                    <td>{data.dept_name}</td>
                    <td>
                      <Checkbox
                        color="primary"
                        name="aaaa"
                        checked={String(state.agency_id) === String(data.idx)}
                        onChange={e => {
                          onChange({
                            target: {
                              name: 'agency_id',
                              value: e.target.checked ? String(data.idx) : ''
                            }
                          })
                        }}
                      />
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </DialogContent>

        <DialogActions>
          <Button color="primary" onClick={() => setPopup(false)}>
            완료
          </Button>
        </DialogActions>
      </Dialog>

    </DefaultTemplate>
  )
}

export default withRouter(FormatModify)