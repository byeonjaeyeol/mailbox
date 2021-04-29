import React from 'react'
import DateFnsUtils from '@date-io/date-fns'
import koLocale from 'date-fns/locale/ko'
import { KeyboardDatePicker, MuiPickersUtilsProvider } from '@material-ui/pickers'

const DatePicker = (props) => {
  return (
    <MuiPickersUtilsProvider utils={DateFnsUtils} locale={koLocale}>
      <KeyboardDatePicker
        autoOk
        disableToolbar
        variant="inline"
        inputVariant="outlined"
        format="yyyy-MM-dd"
        maxDate={new Date('9999-01-01')}
        invalidDateMessage="올바르지 않은 형식입니다."
        InputAdornmentProps={{ position: 'start' }}
        {...props}
      />
    </MuiPickersUtilsProvider>
  )
}

export default DatePicker