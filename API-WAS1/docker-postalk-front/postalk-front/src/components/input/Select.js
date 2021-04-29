import React from 'react'
import { FormControl, InputLabel, Select, MenuItem } from '@material-ui/core'


const SelectComponent = ({label, values = [], ...props}) => {
  // values = [{ text: label, value: '', selected: true }, ...values]

  return (
    <FormControl style={{width: '100%'}}>
      <InputLabel>{label}</InputLabel>
      <Select displayEmpty {...props}>
        {(values.map((x, i) => (
          <MenuItem key={i} {...x}>{x.text || x.value}</MenuItem>
        )))}
      </Select>
    </FormControl>
  )
}

export default SelectComponent
