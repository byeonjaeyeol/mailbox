import React from 'react'
import { TextField } from '@material-ui/core'
import Select from './Select'
import File from './File'
import DatePicker from '../datePicker/DatePicker'

import './input.scss'

const Input = ({ label, type = 'text', ...props }) => {
  const inputTypes = {
    text: 0, password: 0, select: 1, date: 2, file: 3,
  }
  const inputComponents = [TextField, Select, DatePicker, File]
  const TagName = inputComponents[inputTypes[type]]

  return (
    <div className="inputClass">
      {/* <TextField label={label} type={type}></TextField> */}
      <TagName label={label} type={type} {...props}></TagName>
    </div>
  )
}

export default Input
