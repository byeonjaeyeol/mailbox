import React from 'react'
import uuid from 'uuid';
import { Dialog, DialogTitle, DialogContent, DialogActions, Button } from '@material-ui/core'

import './dialog.scss'


const DialogComponent = ({ open, onClose, buttons = [], children, message = {}, className, ...props }) => {
  buttons = [...buttons, { onClick: onClose, color: 'secondary', text: '닫기' }]

  return (
    <Dialog
      open={open}
      onClose={onClose}
      className={className}
      maxWidth={'sm'}
      {...props}
    >
      <DialogTitle>{message.title}</DialogTitle>
      

      <DialogContent>
        {children}
      </DialogContent>

      <DialogActions>
        {buttons.map(button => (
          <Button key={uuid()} onClick={button.onClick} color={button.color}>{button.text}</Button>
        ))}
      </DialogActions>
    </Dialog>
  )
}

export default DialogComponent