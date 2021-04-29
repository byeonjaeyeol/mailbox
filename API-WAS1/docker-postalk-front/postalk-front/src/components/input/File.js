import React, { useState } from 'react'

import uuid from 'uuid';
import { Box, InputBase, IconButton } from '@material-ui/core';
import CloudUpload from '@material-ui/icons/CloudUpload';


const File = ({ label, onChange, ...props }) => {
  const [files, setFiles] = useState([])

  const id = uuid()

  const handleChange = (event) => {
    setFiles([...event.target.files])
    onChange({
      target: {
        name: props.name,
        value: [...event.target.files]
      }
    })
  }

  return (
    <Box display="flex">
      <input
        style={{ display: 'none' }}
        id={id}
        type="file"
        onChange={handleChange}
        {...props}
      />
      <label htmlFor={id}>
        <IconButton size="small" component="span" type="submit">
          <CloudUpload />
        </IconButton>
      </label>
      <Box paddingLeft={1}>
        <InputBase
          placeholder={files.length ? `첨부파일 : ${files.map(x => x.name).join(', ')}` : label}
          readOnly
        ></InputBase>
      </Box>
    </Box>
  )
}

export default File
