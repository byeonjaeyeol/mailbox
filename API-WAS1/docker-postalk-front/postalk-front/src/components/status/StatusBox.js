import React from 'react'
import { Typography, Box } from '@material-ui/core';

import './status.scss';

const StatusBox = ({ bgcolor, color, label, value }) => {
  return (
    <Box bgcolor={bgcolor} color={color} className="status-box">
      <Typography variant="h5" component="h2">{value}</Typography>
      <p>{label}</p>
    </Box>
  )
}

export default StatusBox;
