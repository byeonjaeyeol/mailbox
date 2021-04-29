import React, { useState, useEffect } from 'react'
import { format } from 'date-fns'
import { Paper, Box, TextField, MenuItem } from '@material-ui/core'

import API from '../api/Api'

import { NavLink, withRouter } from 'react-router-dom'
import DefaultTemplate from '../components/template/DefaultTemplate'
import Table from '../components/table/Table'
import MaterialTable, { MTableToolbar } from 'material-table'


const OrgAccount = ({ history }) => {
  const [pageSize, setPageSize] = useState(100)

  const columns = [
    {
      field: 'name',
      title: '이름'
    },
    {
      field: 'hp',
      title: '휴대폰번호'
    },
    {
      field: 'p_code',
      title: 'pcode'
    },
    {
      field: 'entry_dt',
      title: '등록일'
    },
    // {
    //   field: 'idk',
    //   title: '구분'
    // },
    // {
    //   field: 'disp_class',
    //   title: '우편물 수령 방법'
    // }
  ]

  const init = async (page = 0, pageSize = 100, keywords = []) => {
    keywords = keywords.length ? keywords : ''
    const { totalCount = 0, items = [] } = await API.getAccounts('member', { page, pageSize, keywords })

    const data = items.map(item => {
      item.entry_dt = format(new Date(item.entry_dt), 'yyyy-MM-dd HH:mm:dd')
      return item
    })
    
    return {
      data,
      page,
      totalCount
    }
  }

  useEffect(() => {
    init()
  }, [])
  
  const handleRowClick = (e, rowData) => {
    history.push(`/member/account/view/${rowData.uuid}`)
    
    return false
  }

  return (
    <>
      <DefaultTemplate>
        <MaterialTable
          title="회원 계정 관리"
          columns={columns}
          data={query =>
            new Promise((res, rej) => {
              let keywords = query.filters.map(v => ({
                field: v.column.field,
                keyword: v.column.tableData.filterValue
              }))

              init(query.page, query.pageSize, keywords).then(result => {
                res(result)
              })
            })
          }
          onRowClick={handleRowClick}
          options={{
            draggable: false,
            search: false,
            doubleHorizontalScroll: true,
            columnsButton: true,
            filtering: true,
            exportButton: true,
            pageSize,
            pageSizeOptions: [100, 50, 20],
          }}
          components={{
            Container: props => (
              <Paper {...props} className="custom_table" />
            ),
            Toolbar: props => (
              <div className="toolbar">
                <Box display="flex" alignItems="center">
                  <MTableToolbar {...props} />

                  <TextField
                    select
                    value={pageSize}
                    onChange={e => setPageSize(e.target.value)}
                    className="customPageSizeInput"
                  >
                    {[100, 50, 20].map((size, k) => (
                      <MenuItem value={size} key={k}>{size}개 씩</MenuItem>
                    ))}
                  </TextField>
                </Box>
              </div>
            ),
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
              showColumnsTitle: '항목',
              addRemoveColumns: '항목 추가 또는 삭제'
            },
            pagination: {
              labelRowsSelect: `개씩`,
              firstTooltip: '첫번째 페이지',
              previousTooltip: '이전 페이지',
              nextTooltip: '다음 페이지',
              lastTooltip: '마지막 페이지',
              labelDisplayedRows: `{count}개 중 {from}~{to}개`
            }
          }}
        />
      </DefaultTemplate>
    </>
  )
}

export default withRouter(OrgAccount)