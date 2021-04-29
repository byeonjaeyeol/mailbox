import React, { useState } from 'react'
import moment from 'moment'
import { withRouter } from 'react-router-dom';
import { Card, CardContent, Grid, Box, Button, TextField, Typography, MenuItem } from '@material-ui/core'

import API from '../api/Api'
import useInputs from '../hooks/useInputs'

import DefaultTemplate from '../components/template/DefaultTemplate'
import DatePicker  from '../components/datePicker/DatePicker'


const validateDeptCode = (dept_code) => {
  return +dept_code >= 60002 && +dept_code <= 69999
}

const OrgAdd = ({ history }) => {
  const [icon, setIcon] = useState(null)

  const [BC, setBC] = useState({
    channel: [],
    org: []
  })

  const [state, onChange] = useInputs({
    org_code: '',
    org_name: '',
    dept_code: '',
    dept_name: '',
    manager: '',
    contact: '',
    email: '',
    validity_dt: (new moment()).format('YYYY-MM-DD'),
    channel: 'pstchannel1',
    org: 'org1',
    stat_trace: '3',
    rollover_maxage: '30d',
    license_number: ''
  })

  const [validity, setValidity] = useState(new Date())
  

  const init = async () => {
    const channel = await API.getBCChannel()
    const org = await API.getBCOrg()

    setBC({ channel, org })
  }

  const onChangeValidity_dt = (date) => {
    setValidity(date)
    onChange({
      target: {
        name: 'validity_dt',
        value: (new moment(date)).format('YYYY-MM-DD')
      }
    })
  }

  const handleAdd = async () => {
    if (!Object.keys(state).every(key => state[key].trim().length > 0)) {
      return alert('모두 입력해주세요')
    }
    
    if (!icon) {
      return alert('아이콘 파일을 선택해주세요')
    }
    
    if (!validateDeptCode(state.dept_code)) {
      return alert('부서 코드는 60002 ~ 69999 사이의 값만 입력 가능합니다')
    }
    
    const isExistDeptCode = await API.existDeptCode(state.dept_code)

    if (isExistDeptCode) {
      return alert(`${state.dept_code} 부서 코드는 이미 사용 중입니다`)
    }

    const form = new FormData()
    
    Object.keys({...state}).forEach((key, i) => {
      form.append(key, state[key])
    })

    form.append('icon', icon)
    
    const response = await API.addOrg(form)

    if (response.status === 200) {
      alert('발송기관이 등록되었습니다.')
      history.push(`/org`)
    } else {
      alert('발송기관 등록에 실패했습니다.')
    }
  }

  React.useEffect(() => {
    init()
  }, [])


  return (
    <DefaultTemplate>
      <Card>
        <CardContent>
          <Typography variant="h5">발송기관 정보</Typography>
          <br />

          <Grid container spacing={3}>
            <Grid item xs={6}>
              <TextField
                variant="outlined"
                name="org_code"
                value={state.org_code}
                onChange={onChange}
                fullWidth
                label="기관코드"
              />
            </Grid>
            <Grid item xs={6}>
              <TextField
                variant="outlined"
                label="기관명"
                name="org_name"
                value={state.org_name}
                onChange={onChange}
                fullWidth
              />
            </Grid>
            
            <Grid item xs={6} style={{paddingTop: '0px'}}>
              <TextField
                variant="outlined"
                error={!validateDeptCode(state.dept_code)}
                label="부서코드"
                helperText="60002 ~ 69999 사이의 값만 입력 가능"
                name="dept_code"
                value={state.dept_code}
                onChange={onChange}
                fullWidth
              />
            </Grid>
            <Grid item xs={6} style={{paddingTop: '0px'}}>
              <TextField
                variant="outlined"
                label="부서명"
                name="dept_name"
                value={state.dept_name}
                onChange={onChange}
                fullWidth
              />
            </Grid>

            <Grid item xs={6}>
              <div className="dt_input">
                <DatePicker
                  label="청약 만료일"
                  value={validity}
                  onChange={onChangeValidity_dt}
                  minDateMessage={`오늘부터 선택해주세요.`}
                  /* TextFieldComponent={(props) => <TextField {...props} fullWidth />} */
                  disablePast
                  fullWidth
                />
              </div>
            </Grid>

            <Grid item xs={6}>
              <TextField
                variant="outlined"
                type="file"
                name="icon"
                label="아이콘 파일"
                InputLabelProps={{ shrink: true }}
                onChange={(e) => setIcon(e.target.files[0])}
                fullWidth
              />
            </Grid>

            <Grid item xs={12}>
              <TextField
                variant="outlined"
                label="담당자"
                name="manager"
                value={state.manager}
                onChange={onChange}
                fullWidth
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                variant="outlined"
                label="연락처"
                name="contact"
                value={state.contact}
                onChange={onChange}
                fullWidth
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                variant="outlined"
                label="email"
                name="email"
                value={state.email}
                onChange={onChange}
                fullWidth
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                variant="outlined"
                label="사업자 등록번호"
                name="license_number"
                value={state.license_number}
                onChange={onChange}
                fullWidth
              />
            </Grid>

            <Grid item md={12}>
              <br />
              <Typography variant="h5">블록체인 설정</Typography>
            </Grid>

            <Grid item xs={6}>
              <TextField
                variant="outlined"
                label="채널"
                name="channel"
                value={state.channel}
                onChange={onChange}
                fullWidth
                select
              >
                {BC.channel.map(value => (
                  <MenuItem key={value} value={value}>
                    {value}
                  </MenuItem>
                ))}
              </TextField>
            </Grid>

            <Grid item xs={6}>
              <TextField
                variant="outlined"
                label="기관"
                name="org"
                value={state.org}
                onChange={onChange}
                fullWidth
                select
              >
                {BC.org.map(value => (
                  <MenuItem key={value} value={value}>
                    {value}
                  </MenuItem>
                ))}
              </TextField>
            </Grid>

            <Grid item md={12}>
              <br />
              <Typography variant="h5">기타 설정</Typography>
            </Grid>

            <Grid item xs={6}>
              <TextField
                variant="outlined"
                label="통계 추출 기준일"
                name="stat_trace"
                value={state.stat_trace}
                onChange={onChange}
                fullWidth
                select
              >
                {['5', '4', '3', '2'].map(value => (
                  <MenuItem key={value} value={value}>
                    {value}
                  </MenuItem>
                ))}
              </TextField>
            </Grid>

            <Grid item xs={6}>
              <TextField
                variant="outlined"
                label="Index rolling"
                name="rollover_maxage"
                value={state.rollover_maxage}
                onChange={onChange}
                fullWidth
                select
              >
                {['30', '60', '180', '365'].map(value => (
                  <MenuItem key={value} value={`${value}d`}>
                    {value}
                  </MenuItem>
                ))}
              </TextField>
            </Grid>

            <Grid item xs={12}>
              <Box
                width={1}
                display="flex"
                justifyContent="flex-end"
              >
                <Button
                  variant="outlined"
                  color="primary"
                  onClick={handleAdd}
                >등록</Button>
              </Box>
            </Grid>
          </Grid>
        </CardContent>
      </Card>
    </DefaultTemplate>
  )
}

export default withRouter(OrgAdd)
