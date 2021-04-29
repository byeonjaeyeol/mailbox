import React, { useEffect, useState } from 'react'
import { withRouter } from 'react-router-dom'
import moment from 'moment'
import { Card, CardContent, Typography, Grid, Box, Button, TextField, MenuItem } from '@material-ui/core'

import '../style/orgModify.scss'
import API from '../api/Api'
import useInputs from '../hooks/useInputs'

import DefaultTemplate from '../components/template/DefaultTemplate'
import DatePicker from '../components/datePicker/DatePicker'
import {API_ADDRESS} from '../config.js'

//const API_ADDRESS = process.env.NODE_ENV === 'development' ? 'http://localhost:4000/api' : window.location.origin + '/api'


const validateDeptCode = (dept_code) => {
  return +dept_code >= 60002 && +dept_code <= 69999
}


const OrgModify = ({ history, match }) => {
  const [icon, setIcon] = useState(null)

  const [BC, setBC] = useState({
    channel: [],
    org: []
  })

  
  const [image, setImage] = useState(null)

  const [defaultDeptCode, setDefaultDeptCode] = useState('')

  const [state, onChange, dispatch] = useInputs({
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


  const iconSrc = /^https?\:\/\//.test(image) ? image : `${API_ADDRESS}/upload/${image}`


  const init = async () => {
    const [ data ] = await API.getOrg(match.params.orgId)
    const channel = await API.getBCChannel()
    const org = await API.getBCOrg()

    setBC({ channel, org })

    setImage(data.icon_link)

    setDefaultDeptCode(String(data.dept_code))

    dispatch({
      type: 'initial',
      state: Object.keys(state).reduce((acc, key) => (
        { ...acc, [key]: data[key] ? String(data[key]) : '' }
      ), {})
    })

    onChange({
      target: {
        name: 'validity_dt',
        value: (new moment(data.validity_dt)).format('YYYY-MM-DD')
      }
    })

    setValidity(new Date(data.validity_dt))
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

  const handleGoBack = () => {
    history.replace(`/org`)
  }

  const handleModify = async () => {
    if (!Object.keys(state).every(key => state[key].trim().length > 0)) {
      return alert('모두 입력해주세요')
    }

    if (!validateDeptCode(state.dept_code)) {
      return alert('부서 코드는 60002 ~ 69999 사이의 값만 입력 가능합니다')
    }

    if (defaultDeptCode !== state.dept_code) {
      const isExistDeptCode = await API.existDeptCode(state.dept_code)
  
      if (isExistDeptCode) {
        return alert(`${state.dept_code} 부서 코드는 이미 사용 중입니다`)
      }
    }

    const form = new FormData()

    Object.keys({ ...state }).forEach((key, i) => {
      form.append(key, state[key])
    })

    form.append('icon', icon)

    const response = await API.modifyOrg(form, match.params.orgId)

    if (response.status === 200) {
      alert('발송기관이 수정되었습니다.')
      history.replace(`/org`)
    } else {
      alert('발송기관 수정에 실패했습니다.')
    }
  }

  const handleDelete = async () => {
    const response = await API.deleteOrg(match.params.orgId)

    if (response.status === 200) {
      alert('발송기관이 삭제되었습니다.')
      history.replace(`/org`)
    } else {
      alert('발송기관 삭제에 실패했습니다.')
    }
  }

  useEffect(() => {
    init()
  }, [])


  return (
    <DefaultTemplate>
      <Card className="orgModify">
        <CardContent>
          <div className="header">
            <img src={iconSrc} alt="아이콘" />
            <Typography variant="h5">{state.org_name} / {state.dept_name}</Typography>
          </div>

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

            <Grid item xs={6} style={{ paddingTop: '0px' }}>
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
            <Grid item xs={6} style={{ paddingTop: '0px' }}>
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
              <DatePicker
                label="청약 만료일"
                value={validity}
                onChange={onChangeValidity_dt}
                minDateMessage={`오늘부터 선택해주세요.`}
                TextFieldComponent={(props) => <TextField {...props} fullWidth />}
                disablePast
              />
            </Grid>

            <Grid item xs={6}>
              <TextField
                variant="outlined"
                type="file"
                name="icon"
                label="아이콘 파일"
                helperText="파일을 선택하지 않을 시 기존 아이콘으로 유지됩니다."
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
                value={state.email === '' || state.email === 'null' ? '' : state.email}
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

export default withRouter(OrgModify)
