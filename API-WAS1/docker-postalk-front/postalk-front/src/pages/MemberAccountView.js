import React, { useEffect, useState } from 'react'
import { withRouter } from 'react-router-dom'
import { Card, CardContent, Button, Box, TextField } from '@material-ui/core'
import { format } from 'date-fns'

import API from '../api/Api'

import DefaultTemplate from '../components/template/DefaultTemplate'


const MemberAccountView = ({ history, match }) => {
  const [columns, setColumns] = useState([
    { label: '폰 번호', value: '' },
    { label: '이름', value: '' },
    { label: 'pcode', value: '' },
    { label: '비밀번호', value: '' },
    { label: '등록일', value: '' },
    { label: '생년월일', value: '' },
    { label: '주소1', value: '' },
    { label: '주소1 상세', value: '' },
    { label: '주소2', value: '' },
    { label: '주소2 상세', value: '' },
    { label: '차랑 정보', value: '' },
    { label: '우편물 수령 방법', value: '' },
  ])

  const init = async () => {
    const [ data ] = await API.getAccount('member', match.params.memberId)

    setColumns([
      { label: '폰 번호', value: data.hp || '' },
      { label: '이름', value: data.name || '' },
      { label: 'pcode', value: data.p_code || '' },
      { label: '비밀번호', value: data.password || '' },
      { label: '등록일', value: data.entry_dt ? format(new Date(data.entry_dt), 'yyyy-MM-dd') : '' },
      { label: '생년월일', value: data.birth || '' },
      { label: '주소1', value: data.addr1 || '' },
      { label: '주소1 상세', value: data.addr2 || '' },
      { label: '주소2', value: '' },
      { label: '주소2 상세', value: '' },
      { label: '차랑 정보', value: data.car_num || '' },
      { label: '우편물 수령 방법', value: '' },
    ])
  }

  useEffect(() => {
    init()
  }, [])

  const handleGoList = () => {
    history.push('/member/account')

    return false
  }

  return (
    <DefaultTemplate>
      <Card className="memberAccountView">
        <CardContent>
          <Box padding={1}>
            {columns.map((column, i) => (
              <div style={{ marginBottom: 24 }}>
                <TextField
                  variant="outlined"
                  label={column.label}
                  value={column.value}
                />
              </div>
            ))}
            <Box
              width={1}
              display="flex"
              justifyContent="flex-end"
            >
              <Button
                onClick={handleGoList}
                variant="outlined"
                color="primary"
              >목록</Button>
            </Box>
          </Box>
        </CardContent>
      </Card>
    </DefaultTemplate>
  )
}

export default withRouter(MemberAccountView)
