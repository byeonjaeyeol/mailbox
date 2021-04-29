import React from 'react'
import Input from '../input/Input'

const ViewForm = ({ label, children, ...props }) => {
  return (
    <Input
      readOnly
      label={label}
      value={children}
      {...props}
    ></Input>
  )
}

export default ViewForm
