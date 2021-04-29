import React from 'react'
import { Button, Typography } from '@material-ui/core'

import '../style/404.scss'

const PageNotFound = ({ history }) => {
  const handleMoveHomePage = () => {
    history.replace('/')
  }

  const handleMovePrevPage = () => {
    history.goBack()
  }

  return (
    <div className="page-error">
      <Typography variant="h3" gutterBottom>서비스 준비 중입니다</Typography>

      <div className="buttons">
        <Button onClick={handleMoveHomePage} color="primary">홈 페이지</Button>
        <Button onClick={handleMovePrevPage} color="secondary">이전 페이지</Button>
      </div>
    </div>
  )
}

export default PageNotFound