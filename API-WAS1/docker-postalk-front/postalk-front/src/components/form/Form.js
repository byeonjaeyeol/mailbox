import React from 'react'

const Form = ({ ...props }) => {
  return (
    <form
      {...props}
    >
      {children}
    </form>
  )
}

export default Form
