import React, { useState, useEffect } from 'react'
import { format } from 'date-fns'
import moment from 'moment'

import './datePicker.scss'

import DatePicker from './DatePicker'


const StartEndDatePicker = ({ start, end, onChange }) => {
  const [state, setState] = useState({ start, end })

  const isDate = (date) => {
    return date != 'Invalid Date' && date !== null
  }

  const getDate = (state) => {
    return isDate(state) ? format(state, 'yyyy-MM-dd') : ''
  }

  const handleDateChange = (start, end) => {
    isDate(start) && isDate(end) && onChange(start, end)
    setState({ start, end })
  }

  useEffect(() => {
    if (start && end) {
      setState({ start, end })
    }
  }, [start, end])


  return (
    <div className="start_end_date_picker">
      <DatePicker
        label="시작일"
        value={state.start}
        onChange={date => handleDateChange(new Date(moment(date).format('YYYY-MM-DD 00:00:00')), state.end)}
      />

      <span>~</span>

      <DatePicker
        label="종료일"
        value={state.end}
        minDate={state.start}
        minDateMessage={`시작일인 ${getDate(state.start)} 부터 입력해주세요.`}
        onChange={date => handleDateChange(state.start, new Date(moment(date).format('YYYY-MM-DD 23:59:59')))}
      />
    </div>
  )
}

export default StartEndDatePicker