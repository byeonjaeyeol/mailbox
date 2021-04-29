import React, { useState, useEffect, useMemo } from 'react'
import { Paper, Box, Tooltip, TextField, MenuItem } from '@material-ui/core'
import MaterialTable, { MTableToolbar } from 'material-table'
import StartEndDatePicker from '../datePicker/StartEndDatePicker'
import DatePicker from '../datePicker/DatePicker'
import moment from 'moment'

import clsx from 'clsx'
import produce from 'immer'

import './table.scss'


const Table = ({ term = false, termStart = '', termColumn = '', start = '', end = '', scrollable = false, useTermDiffValidate = false, components = {}, label = '개', options = {}, localization = {}, isAddToolbar = false, AddToolbar = {}, AddToolbarProps = {}, data = [], ...props }) => {
  const pageSizeOptions = options.pageSizeOptions || [100, 50, 20]

  const [pageSize, setPageSize] = useState(options.pageSize || 100)
  const [searched, setSearched] = useState([])
  const [filter, setFilter] = useState({
    start: new Date(termStart || '2019-01-01'),
    end: new Date()
  })

  const handleChangeDate = (start, end) => {
    if (useTermDiffValidate && moment(end).diff(moment(start), 'months', true) > 3) {
      alert('3개월 이내의 정보만 조회 가능합니다.')

      setFilter({
        start: new Date((new moment(end)).subtract(3, 'months').format('YYYY-MM-DD')),
        end
      })

      return false
    } 

    if (props.setDate) {
      props.setDate({ start, end })
    }

    setFilter({ start, end })
  }

  useEffect(() => {
    Array.isArray(data) && (
      setSearched(data.filter(item => (
        (!term || !filter.start || filter.start <= new Date(item[termColumn]))
        && (!term || !filter.end || filter.end >= new Date(item[termColumn]))
      )))
    )
  }, [data, filter.start, filter.end])


  return (
    <div style={{position: 'relative'}}>
      {term && (
        <div style={{
          position: 'absolute',
          right: '30px',
          top: '20px',
          zIndex: 999
        }}>
          <StartEndDatePicker
            start={filter.start}
            end={filter.end}
            onChange={handleChangeDate}
          />
        </div>
      )}
      <MaterialTable
        key={pageSize}
        data={searched}
        components={{
          Container: props => (
            <Paper {...props} className={clsx('custom_table', scrollable && 'scrollable')} />
          ),
          Toolbar: props => (
            <div className="toolbar">
              <Box display="flex" alignItems="center">
                <MTableToolbar {...props} />
                
                {isAddToolbar && (
                  <AddToolbar {...AddToolbarProps}></AddToolbar>
                )}

                <TextField
                  select
                  value={pageSize}
                  onChange={e => setPageSize(e.target.value)}
                  className="customPageSizeInput"
                >
                  {pageSizeOptions.map((size, k) => (
                    <MenuItem value={size} key={k}>{size}개 씩</MenuItem>
                  ))}
                </TextField>
              </Box>
            </div>
          ),
          ...components
        }}
        localization={{
          body: {
            emptyDataSourceMessage: '검색된 항목이 없습니다.',
            filterRow: {
              filterTooltip: '필터'
            },
            editRow: {
              saveTooltip: '확인',
              cancelTooltip: '취소',
              deleteText: '정말로 이 항목을 삭제하시겠습니까?'
            },
            addTooltip: '추가',
            deleteTooltip: '삭제',
            editTooltip: '수정'
          },
          grouping: {
            placeholder: '이쪽에 제목을 드래그해 그룹화'
          },
          toolbar: {
            searchTooltip: '검색',
            searchPlaceholder: '검색',
            exportTitle: '엑셀 다운로드',
            exportName: 'CSV 다운로드',
            showColumnsTitle: '필터',
            addRemoveColumns: '필터 추가 또는 삭제'
          },
          pagination: {
            labelRowsSelect: `${label}씩`,
            firstTooltip: '첫번째 페이지',
            previousTooltip: '이전 페이지',
            nextTooltip: '다음 페이지',
            lastTooltip: '마지막 페이지',
            labelDisplayedRows: `{count}${label} 중 {from}~{to}${label}`
          },
          ...localization
        }}
        options={{
          draggable: false,
          search: false,
          doubleHorizontalScroll: true,
          columnsButton: true,
          ...options,
          pageSize,
          pageSizeOptions
        }}
        {...props}
      />
    </div>
  )
}

export default Table