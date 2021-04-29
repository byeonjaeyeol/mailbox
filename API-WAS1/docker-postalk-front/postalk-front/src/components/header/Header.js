import React from 'react'
import { withRouter } from 'react-router-dom'
import { AppBar, Toolbar, IconButton, Typography, Icon, Box, Tooltip } from '@material-ui/core'

import './header.scss'

const Header = ({ history }) => {

  const handleSignOut = () => {
    localStorage.removeItem('token')
    localStorage.removeItem('type')

    window.location.href = '/login'
  }

  return (
    <AppBar position="fixed">
      <Toolbar>
        <Box display="flex" justifyContent="space-between" alignItems="center" width="100%">
          <Box display="flex" alignItems="center">
            <Typography variant="h6">
              전자우편사서함 관리자 포털
            </Typography>
          </Box>

          <Tooltip title="로그아웃">
            <IconButton
              edge="start"
              color="inherit"
              aria-label="menu"
              onClick={handleSignOut}
            >
              <Icon>lock_open</Icon>
            </IconButton>
          </Tooltip>
        </Box>
      </Toolbar>
    </AppBar>
  )
}

export default withRouter(Header)