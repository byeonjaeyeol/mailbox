import React from 'react';
import { Typography } from '@material-ui/core'
import clsx from 'clsx';

import './status.scss'

const StatusColumn = ({ title, content, footer, nonBorder }) => {
  return (
    <div className={clsx('status-column', nonBorder && 'status-column--non-border')}>
      <Typography variant="h5" component="h2">{title}</Typography>
      <Typography variant="h3" component="div">{Math.floor(content * 10) / 10}%</Typography>
      <p>{footer}</p>
    </div>
  )
}

export default StatusColumn;
