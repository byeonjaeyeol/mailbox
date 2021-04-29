import React from 'react'
import { CircularProgress } from '@material-ui/core'

import './loading.scss'

const Loading = () => {
  return (
    <div className="loading">
      <CircularProgress thickness={2.5} />
      잠시만 기다려주세요.
    </div>
  )
}

export default Loading