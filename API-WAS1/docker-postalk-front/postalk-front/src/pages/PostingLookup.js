import React, { useState, useEffect } from 'react'
import { Box, TextField, MenuItem, Paper, Button, CircularProgress, Typography, Dialog as MDialog, DialogTitle, DialogContent, DialogContentText, DialogActions, Checkbox } from '@material-ui/core'
import MaterialTable from 'material-table'
import { format } from 'date-fns'
import producer from 'immer'
import qs from 'qs'
import moment from 'moment'

import '../components/queryTrace/queryTrace.scss'
import API from '../api/Api'

import DefaultTemplate from '../components/template/DefaultTemplate'
import StartEndDatePicker from '../components/datePicker/StartEndDatePicker'
import Dialog from '../components/dialog/Dialog'
import Table from '../components/table/Table'

import {CERT_API_URL} from '../config'


const delay = 150
let timeoutHandle

//todo auto ->
const DISP_CLASS = {
  0: '차단',
  1: '포스톡',
  2: 'MMS',
  4: '종이우편',
  6: '종이우편',
  8: 'EMAIL',
  'auto': '모바일우편'
}

const DISP_STATUS = {
  waiting: '발송대기',
  ing: '발송처리중',
  done: '발송완료'
}

const DM_TYPE = {
  registered: '등기통상',
  general: '일반통상'
}

//todo 미열람으로 인한 실물전환
const DISP_CONVERT = {
    'auto-4' : 'Y',
    'auto-14' : 'Y'
}

const DISP_END = {
  1 : '모바일',
  4 : '실물우편'
}

const queryTraceInfoColumns = [
  {
    field: 'regino',
    title: '등기번호'
  },
  {
    title: '보내는분/발송날짜',
    render: rowData => (
      <>
        {rowData.sendnm}
        <br />
        {rowData.itemlist[0].sortingdate}
      </>
    )
  },
  {
    title: '받는분/수신날짜',
    render: rowData => (
      <>
        {rowData.recevnm}
        <br />
        {rowData.eventymd}
      </>
    )
  },
  {
    field: 'mailkindnm',
    title: '취급구분'
  },
  {
    title: '배달결과',
    render: rowData => (
      <>
        {rowData.itemlist[rowData.itemlist.length - 1].tracestatus}
        {rowData.itemlist[rowData.itemlist.length - 1].nondelivreasnnm && (
          <>
            <br />
            사유: <span style={{ color: '#ef5350' }}>{rowData.itemlist[rowData.itemlist.length - 1].nondelivreasnnm}</span>
          </>
        )}
      </>
    )
  },
]

const queryTraceColumns = [
  {
    field: 'sortingdate',
    title: '날짜'
  },
  {
    field: 'eventhms',
    title: '시간'
  },
  {
    field: 'eventregiponm',
    title: '발생국'
  },
  {
    field: 'tracestatus',
    title: '처리현황',
    render: rowData => (
      <>
        {rowData.tracestatus}
        {rowData.nondelivreasnnm && (
          <>
            <br/>
            사유: <span style={{ color: '#ef5350' }}>{rowData.nondelivreasnnm}</span>
          </>
        )}
      </>
    )
  }
]


const PostingLookup = () => {
  const signUserType = localStorage.getItem('type')
  //kimcy add
  const signUserAuthority = localStorage.getItem('authority')

  const tableRef = React.useRef()

  const [popup, setPopup] = useState(false)

  const [agencyData, setAgencyData] = useState([])

  const [dialog, setDialog] = useState({
    open: false,
    query: '',
    data: false
  })
//todo
  const [filter, setFilter] = useState({
    org_code: '',
    dept_code: '',
    org_idx: '',
    start: new Date((new moment()).subtract(3, 'months').format('YYYY-MM-DD')),
    end: new Date()
  })

  const [searchType, setSearchType] = useState('name')
  const [keyword, setKeyword] = useState('')

  const [pageData, setPageData] = useState({
    page: 0,
    nowBlock: 0,
    totalCount: 0,
    html: [],
    pageSize: 100
  })

  const openCertWindow = async (data) => {

    const queryStringObj = {
      docid: data.id,
      docindex: data.index,
      agencyindex: data.org_idx
    }

    if (signUserType !== 'system') {
      queryStringObj.agencyuser = localStorage.getItem('userId')
    }

    const queryString = qs.stringify(queryStringObj)

    window.open(`${CERT_API_URL}?${queryString}`, '_blank')
  }

  const columns = [
    {
      field: 'org_name',
      title: '발송기관'
    },
    {
      field: 'groupId',
      title: '송신시간'
    },
    {
      field: 'reg_dt',
      title: '수신시간'
    },
    {
      field: 'read_dt',
      title: '열람시간'
    },
    {
      field: 'dept_name',
      title: '발송부서'
    },
    {
      field: 'name',
      title: '수신자명'
    },
    /*{
      field: 'template_code',
      title: '서식 코드'
    },*/
    {
      field: 'doc_title',
      title: '문서 제목'
    },
    {
      field: 'dm_type',
      title: '우편 구분'
    },
    {
      field: 'dm_reg_num',
      title: '등기번호',
      render: rowData => (
        <Button color="primary" onClick={() => handleOpenDialog(rowData.dm_reg_num)}>{rowData.dm_reg_num}</Button>
      )
    },
    {
      field: 'id',
      title: '수발신증명서',
      render: rowData => (
        <Button color="primary" variant="contained" onClick={() => openCertWindow(rowData)} disableElevation>발급</Button>
      )
    },
    {
      field: 'disp_class',
      title: '발송요청방식'
    },
    {
      field: 'disp_status',
      title: '발송상태'
    },
    {
      field: 'disp_convert',
      title: '실물전환여부'
    },
    {
      field: 'disp_end',
      title: '실제발송방식',
     // lookup: { '모바일': '모바일', '실물우편': '실물우편' },
    },
    {
      field: 'request_id',
      title: '접수번호'
    },
    {
      field: 'is_readed',
      title: '모바일열람여부'
    },
    {
      field: 'read_at',
      title: '우편열람시간',
      render: rowData => rowData.read_at ? format(new Date(rowData.read_at), 'yyyy-MM-dd HH:mm:dd') : ''
    }
  ]

  const init = async () => {
    //kimcy add authority
    if (signUserType === 'org' && signUserAuthority !== 'admin') {
      const userId = localStorage.getItem('userId')
      const [user] = await API.getAccount('org', userId)
      const { org_code, dept_code } = await API.searchOrg('name', user.org_name, user.dept_name)

      setFilter({
        ...filter,
        org_code,
        dept_code
      })
    } else {
      const response = await API.getOrgs()

      setAgencyData(response)
    }
  }

  const getDt = (dt, type = 'start') => {
    return moment(`${moment(dt).format('YYYY-MM-DD')} ${type === 'start' ? '00:00:00' : '23:59:59'}`).toISOString()
  }

  const getPostingLookup = async(page, page_size) => {
    /* const dt = new Date(filter.end)
    dt.setDate(dt.getDate()+1) */

    

    const { hits } = await API.getPostSend({
      ...filter,
      page_from: page * page_size,
      page_size,
      start: getDt(filter.start, 'start'),
      end: getDt(filter.end,'end'),
      [searchType]: window.document.querySelector('.searchTextField .MuiInputBase-input').value
    })

    if (!hits || hits.hits.length < 1) {
      return {
        data: [],
        page: page,
        totalCount: 0
      }
    }

    const { org_name, dept_name } = await API.searchOrg('code', filter.org_code, filter.dept_code)
   // todo: dm_type
    const data = hits.hits.map(item => ({
      org_name,
      dept_name,
      org_idx: filter.org_idx,
      id: item._id,
      index: item._index,
      name: item._source.binding.reserved.additional.receiver.name,
      dm_type: item._source.binding.reserved.essential.dispatching.dm ? (DM_TYPE[item._source.binding.reserved.essential.dispatching.dm['type']] || '') : '',
      dm_reg_num: item._source.binding.reserved.essential.dispatching.dm ? item._source.binding.reserved.essential.dispatching.dm['reg-num'] : '',
      reg_dt: item._source.status.time['@analysised'],
      read_at: item._source.status.time['@read'],
     // template_code: item._source.binding.reserved.essential.template.code,
      doc_title: item._source.binding.reserved.essential.template.title,
      disp_class: DISP_CLASS[item._source.binding.reserved.essential.dispatching.class],
      disp_status: DISP_STATUS[item._source.status.dispatching],
      request_id: item._source.binding.reserved.essential.search['request-id'],
      groupId: item._source.status.time['@registed'] ? moment(item._source.status.time['@registed']).format('YYYY-MM-DD HH:mm:ss') : '',
      is_readed: String(item._source.status.read) === '0' ? '-' : '열람',
      tmp_dm_type : item._source.binding.reserved.essential.dispatching.class,
      disp_convert : item._source.binding.reserved.essential.dispatching.class + '-'+ item._source.status.class,
      disp_end : DISP_END[item._source.status.class],
      read_dt : item._source.status.time['@read'] ? moment(item._source.status.time['@read']).format('YYYY-MM-DD HH:mm:ss') : ''
    })).map(v => ({
      ...v,
      reg_dt: format(new Date(v.reg_dt), 'yyyy-MM-dd HH:mm:dd'),
      dm_reg_num: v.dm_reg_num+'',
      dm_type : v.tmp_dm_type === 'auto' ? '모바일우편' : v.dm_type,
      //disp_convert : DISP_CONVERT[v.disp_convert] == 0 ? 'Y' : 'N'
      disp_convert : DISP_CONVERT[v.disp_convert] === 'Y' ? 'Y' :'N'
    }))

    setPageData(producer(v => {
      v.totalCount = hits.total
      v.page = page
      v.pageSize = page_size
    }))

    return {
      data,
      page: page,
      totalCount: hits.total
    }
  }

  const handleChangeFilterValue = (key, value) => {
    setFilter(producer(draft => {
      draft[key] = value
    }))
  }

  const handleChangeDate = (start, end) => {
    if (moment(end).diff(moment(start), 'months', true) > 3) {
      alert('3개월 이내의 정보만 조회 가능합니다.')

      setFilter({
        ...filter,
        start: new Date((new moment(end)).subtract(3, 'months').format('YYYY-MM-DD')),
        end
      })
    } else {
      setFilter({
        ...filter,
        start,
        end
      })
    }
  }

  const queryChange = () => {
    clearTimeout(timeoutHandle)
  
    timeoutHandle = setTimeout(() => {
      tableRef.current && tableRef.current.onQueryChange()
    }, delay)
  }

  const handleOpenDialog = (query) => {
    setDialog({
      ...dialog,
      open: true,
      data: false,
      query
    })
  }

  const handleCloseDialog = () => {
    setDialog({
      ...dialog,
      open: false
    })
  }

  const queryTrace = async () => {
    const { trace } = await API.queryTrace(dialog.query)
    let data = null

    if (trace) {
      data = Object.keys(trace).reduce((acc, key) => ({
        ...acc,
        [key]: trace[key][0]
      }), {})

      data.itemlist = data.itemlist.item.map(item => Object.keys(item).reduce((acc, key) => ({
        ...acc,
        [key]: item[key][0]
      }), {}))
    }

    setDialog({
      ...dialog,
      data
    })
  }

  const getPageBlock = () => {
    const page = pageData.page
    const totalCount = Math.ceil(pageData.totalCount / pageData.pageSize)
    const nowBlock = Math.floor(page / 10)

    let html = []

    for (let i = nowBlock*10+1; i <= (nowBlock+1)*10; i++) {
      if (i <= totalCount) {
        html.push(<button className={i-1 === page ? 'active' : ''} onClick={() => {
          tableRef.current.state.query.page = i - 1
          tableRef.current.state.pageSize = pageData.pageSize
          tableRef.current.onQueryChange()
        }}>{i}</button>)
      }
    }

    setPageData(producer(v => {
      v.nowBlock = nowBlock
      v.html = html
    }))
  }

  useEffect(() => {
    getPageBlock()
  }, [pageData.page, pageData.totalCount, pageData.pageSize])

  useEffect(() => {
    init()
  }, [])

  useEffect(() => {
    queryChange()
  }, [filter])

  useEffect(() => {
    if (dialog.open) {
      setTimeout(() => {
        queryTrace()
      }, 1000)
    }
  }, [dialog.open])


  return (
    <DefaultTemplate>

      <Dialog open={dialog.open} onClose={handleCloseDialog} message={{ title: '등기번호 조회' }} maxWidth="md" className="queryTraceDialog" fullWidth>
        {dialog.data === false && (
          <div className="empty">
            <CircularProgress />
          </div>
        )}

        {dialog.data === null && (
          <div className="empty">
            <Typography>검색 결과가 없습니다</Typography>
          </div>
        )}

        {(dialog.data) instanceof Object && (
          <>
            <Table
              title="기본 정보"
              columns={queryTraceInfoColumns}
              data={[ dialog.data ]}
              options={{
                paging: false,
                columnsButton: false
              }}
            />

            <br />
            <br />

            <Table
              title="추적 정보"
              columns={queryTraceColumns}
              data={dialog.data.itemlist}
              options={{
                paging: false,
                columnsButton: false
              }}
            />
          </>
        )}
      </Dialog>

      <Box marginY={2}>
        <Paper>
          <Box display="flex" alignItems="center" justifyContent="space-between" padding={2}>
            <Box display="flex" alignItems="center">
              {(signUserType === 'system' || signUserAuthority === 'admin')&& (
                <>
                  <Button color="primary" variant="contained" onClick={() => setPopup(true)}>기관 선택</Button>
                  <div style={{ margin: '0 24px', color: '#aaa' }}>|</div>
                </>
              )}


              <TextField size="small" variant="outlined" value={searchType} onChange={e => setSearchType(e.target.value)} style={{ marginRight: 4 }} select>
                <MenuItem value="name">수신자명</MenuItem>
                <MenuItem value="reg_num">등기번호</MenuItem>
                <MenuItem value="req_id">접수번호</MenuItem>
              </TextField>

              <TextField size="small" className="searchTextField" variant="outlined" placeholder="검색" style={{ marginRight: 4, width: 200 }} />

              <Button color="primary" variant="contained" onClick={queryChange}>검색</Button>
            </Box>

            <StartEndDatePicker
              start={filter.start}
              end={filter.end}
              onChange={handleChangeDate}
            />
          </Box>
        </Paper>
      </Box>

      <div className="postingLookupTable">
        <MaterialTable
          title="우편물 발송 조회"
          tableRef={tableRef}
          columns={columns}
          data={query =>
            new Promise((res, rej) => {
              getPostingLookup(query.page, query.pageSize)
                .then(result => res(result))
            })
          }
          options={{
            draggable: false,
            search: false,
            doubleHorizontalScroll: true,
            columnsButton: true,
            sorting: false,
            filtering: false,
            exportButton: true,
            pageSize: pageData.pageSize,
            pageSizeOptions: [100, 50, 20],
          }}
          components={{
            Container: props => (
              <Paper {...props} className="custom_table scrollable" />
            )
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
      </div>


      <div className="paging">
        {pageData.html}
      </div>

      <MDialog open={popup} onClose={() => setPopup(false)} >
        <DialogTitle>기관선택</DialogTitle>

        <DialogContent>
          <table className="c-table">
            <thead>
              <th>기관 코드</th>
              <th>부서 코드</th>
              <th>기관 이름</th>
              <th>부서 이름</th>
              <th>선택</th>
            </thead>

            <tbody>
              {agencyData.map(data => {

                return (
                  <tr key={data.idx}>
                    <td>{data.org_code}</td>
                    <td>{data.dept_code}</td>
                    <td>{data.org_name}</td>
                    <td>{data.dept_name}</td>
                    <td>
                      <Checkbox
                        color="primary"
                        name="aaaa"
                        checked={filter.org_code === data.org_code && filter.dept_code === data.dept_code}
                        onChange={e => {
                          if (e.target.checked) {
                            setFilter({
                              ...filter,
                              org_code: data.org_code,
                              dept_code: data.dept_code,
                              org_idx: data.idx
                            })
                          }
                        }}
                      />
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </DialogContent>

        <DialogActions>
          <Button color="primary" onClick={() => setPopup(false)}>
            완료
          </Button>
        </DialogActions>
      </MDialog>
    </DefaultTemplate>
  )
}

export default PostingLookup