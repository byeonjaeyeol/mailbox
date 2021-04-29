import React from 'react'
import { Breadcrumbs, Link, Box } from '@material-ui/core';
import { findRoutes } from '../../configs/routes'
import { withRouter } from 'react-router-dom';
import NavigateNextIcon from '@material-ui/icons/NavigateNext';
import Nav from '../nav/Nav'
import Header from '../header/Header'

import './template.scss'

const DashBoardTemplate = ({ match, children }) => {
  const breadcrumbs = findRoutes(match.path)

  return (
    <div className="template-dashboard">
      <Header />
      <Nav />
      <main>
        {breadcrumbs.length && 
          <Box padding={2} bgcolor="#e0e0e0" marginBottom={4} className="breadcrumbs-box">
            <Breadcrumbs separator={<NavigateNextIcon fontSize="small" />} aria-label="breadcrumb" className="breadcrumbs">
              {breadcrumbs.map((breadcrumb, i) => (
                i !== breadcrumbs.length - 1 ? (
                  <Link color="inherit" href={breadcrumb.path} key={i}>
                    {breadcrumb.label}
                  </Link>
                ) : (
                    <p key={i}>{breadcrumb.label}</p>
                  )
              ))}
            </Breadcrumbs>
          </Box>
        }
        { children }
      </main>
    </div>
  )
}

export default withRouter(DashBoardTemplate)