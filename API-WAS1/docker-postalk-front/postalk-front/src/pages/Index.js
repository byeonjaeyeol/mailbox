import React, { useEffect, useRef, useState } from 'react'

import { Paper, Box, Grid, Typography, Button, ButtonGroup, Icon, IconButton, TextField, Dialog, DialogTitle, DialogContent, DialogActions, DialogContentText, Checkbox } from '@material-ui/core'
import ArrowBackIcon from '@material-ui/icons/ArrowBack';
import ArrowForwardIcon from '@material-ui/icons/ArrowForward';
import produce from 'immer';
import clsx from 'clsx';
import Chart from 'chart.js';

import DefaultTemplate from '../components/template/DefaultTemplate'
import StatusBox from '../components/status/StatusBox';
import StatusColumn from '../components/status/StatusColumn';

import Api from '../api/Api';

import '../style/main.scss';
import useStyle from '../style/style'
import { format, subDays, subMonths, subYears, subWeeks, addDays } from 'date-fns';

const number = new Intl.NumberFormat();

const DashBoardTitle = ({ title, buttons, onButtonClick, active }) => {
  return (
    <Box display="flex" alignItems="center" marginBottom={4}>
      <Typography variant="h5" component="h3">{title}</Typography>
      {
      buttons && 
        <Box marginLeft={4}>
          <ButtonGroup color="primary" size="large">
            {buttons.map((button, key) => (
              <Button variant={active === button.value ? 'contained' : ''} key={key} onClick={_ => onButtonClick(button.value)}>{button.label}</Button>
            ))}
          </ButtonGroup>
        </Box>
      }
    </Box>
  )
}

let charts = {
  send: [],
  receive: [],
  dayBySignUp: [],
};

const Index = () => {
  const classes = useStyle({})
  const [state, setState] = useState({
    setting: {
      sendLookupRange: 'day',
      receiveLookupRange: 'total',
      signUpLookupRange: 'day',
      signUpDate: new Date(),
      stardendDate: new Date(),
      agency: null,
      format: null,
    },

    value: {
      sendData: {
        totalAPPCnt: 0,
        totalMMSCnt: 0,
        totalDMCnt: 0,
        allCnt: 0,
        list: [],
      },
      receiveData: {
        allCnt: 0,
        failCnt: 0,
        denyCnt: 0,
        waitCnt: 0,
        totalAPPCnt: 0,
        totalMMSCnt: 0,
      },
      signUpData: {
        list: [],
        allCnt: 0
      },
      dayBySignUpData: {
        list: [],
        allCnt: 0
      },

      agencyData: [],
      formatData: []
    },

    popup: {
      agency: false,
      format: false,
    }
  });
  const dateByTypeCanvas = useRef(null);
  const dateBySendCanvas = useRef(null);
  const typeByCanvas = useRef(null);
  const signUpCanvas = useRef(null);
  const dateBySignUpCanvas = useRef(null);

  const { sendData, dayBySignUpData, receiveData } = state.value;

  const beforeSendDataGap = sendData.list.length >= 2 ? 
    sendData.list[sendData.list.length - 1].allCnt - sendData.list[sendData.list.length - 2].allCnt
    : 0;
  const [receiveLookupDataLabel, receiveLookupData] = (() => {
    console.log(receiveData);

    switch (state.setting.receiveLookupRange) {
      case 'total':
        return [['발송요청중', '발송요청완료', '발송완료'], [
          receiveData.ingMMSCnt + receiveData.ingDMCnt + receiveData.ingDenyCnt,
          receiveData.dispMMSCnt + receiveData.dispDMCnt + receiveData.dispDenyCnt,
          receiveData.doneMMSCnt + receiveData.doneDMCnt + receiveData.doneDenyCnt + receiveData.doneAPPCnt
        ]];
      case 'app':
        return [['발송완료'], [receiveData.doneAPPCnt]];
      case 'mms':
        return [['발송요청중', '성공', '실패'], [receiveData.ingMMSCnt + receiveData.dispMMSCnt, receiveData.resultMMSSucCnt, receiveData.resultMMSFailCnt]]
      case 'dm':
        return [['발송요청중', '발송완료'], [receiveData.ingDMCnt + receiveData.dispDMCnt, receiveData.doneDMCnt]]
      case 'deny':
        return [['발송요청중', '발송완료'], [receiveData.ingDenyCnt + receiveData.dispDenyCnt, receiveData.doneDenyCnt]]
      case 'dmLink':
        return [['DM 연계 발송 수'], [receiveData.retryMMSDmCnt]]
      case 'fail':
        return [['차단으로 인해 DM 연계 발송 요청 실패', 'mms 발송 실패로 DM 연계 발송 요청 실패', '기타 발송 요청 실패'], [receiveData.failedDenyCnt, receiveData.failedRetryCnt, receiveData.failCnt]]
      default:
        return [[1, 2], [receiveData.allCnt + receiveData.waitCnt, receiveData.failCnt]];
    }
  })()
  
  const receiveLookupDataTotal = receiveLookupData.reduce((acc, next) => acc + next);
  const beforeLabel = {
    'day': '전일',
    'week': '전주',
    'month': '전월',
    'year': '전년'
  }

  useEffect(() => {
    setSignUpData();
    setDayBySignUpData();
    setAgencyData();
  }, [state.setting.stardendDate])

  useEffect(() => {
    setSendData(state.setting.sendLookupRange);
    setReceiveData();
  }, [state.setting.stardendDate, state.setting.agency, state.setting.format])

  useEffect(() => {
    const { sendData } = state.value;

    charts.send.map(chart => chart.destroy())

    /* charts.send[0] = new Chart(dateByTypeCanvas.current.getContext('2d'), {
      type: 'bar',
      data: {
        labels: ['모바일우편', '문자우편', '종이우편'],
        datasets: [{
          label: '발송건수',
          data: [sendData.totalAPPCnt, sendData.totalMMSCnt, sendData.totalDMCnt],
          backgroundColor: [
            '#f5b53e',
            '#5b9494',
            '#143761',
          ]
        }],
      },
      options: {
        scales: {
          yAxes: [{
            ticks: {
              min: 0,
              beginAtZero: true
            },
          }],
          xAxes: [{
            gridLines: {
              color: "rgba(0, 0, 0, 0)",
            }
          }]
        },
        legend: {
          display: false
        },
        tooltips: {
          callbacks: {
            label: function(tooltipItem) {
              return tooltipItem.yLabel;
            }
          }
        }
      }
    }) */

    let labels = []
    let sendCnt = {
      'totalAPPCnt': [],
      'totalMMSCnt': [],
      'totalDMCnt': []
    }

    // 평균
    let avgCnt = {
      'day': 1,
      'week': 5,
      'month': 1,
      'year': 1
    }[state.setting.sendLookupRange]

    sendData.list.map(v => {
      if (state.setting.sendLookupRange === 'month') {
        let ym = v.regDt.replace(/[년월]/g, '').split(' ')
        let y = ym[0] * 1
        let m = ym[1] * 1

        let end = new Date(y, m, 0)
        let endDate = end.getDate()

        // 해당 월의 평일수
        let totalDate = endDate

        for (let i = 0; i <= endDate; i++) {
          const day = new Date(y, m, i).getDay()

          if (day === 0 || day === 6) {
            totalDate--
          }
        }

        avgCnt = totalDate
      }

      console.log(v.totalAPPCnt)

      labels.push(v.regDt)
      sendCnt.totalMMSCnt.push(v.totalMMSCnt/*  / avgCnt */)
      sendCnt.totalAPPCnt.push(v.totalAPPCnt/*  / avgCnt */)
      sendCnt.totalDMCnt.push(v.totalDMCnt/*  / avgCnt */)
    })

    if (labels.length === 1 && state.setting.sendLookupRange === 'year') {
      labels.unshift(labels[0].replace('년', '') * 1 - 1)
      sendCnt.totalAPPCnt.unshift(0)
      sendCnt.totalMMSCnt.unshift(0)
      sendCnt.totalDMCnt.unshift(0)
    }

    // sendData.list
    // 기간별 우편발송 현황 데이터 좌측
    charts.send[0] = new Chart(dateByTypeCanvas.current.getContext('2d'), {
      type: 'line',
      data: {
        labels: labels,
        datasets: [
          {
            label: '모바일우편',
            backgroundColor: 'rgba(255,85,74,0)',
            borderColor: 'yellow',
            minBarLength: 2,
            data: sendCnt.totalAPPCnt
          },
          {
            label: '종이우편',
            backgroundColor: 'rgba(255,85,74,0)',
            borderColor: 'red',
            minBarLength: 2,
            data: sendCnt.totalDMCnt
          },
          {
            label: '문자우편',
            backgroundColor: 'rgba(255,85,74,0)',
            borderColor: 'green',
            minBarLength: 2,
            data: sendCnt.totalMMSCnt
          },
        ]
      },
      options: {
        scales: {
          yAxes: [{
            ticks: {
              min: 0,
              beginAtZero: true
            }
          }]
        },
        legend: {
          display: false
        },
        tooltips: {
          callbacks: {
            label: function(tooltipItem) {
              return tooltipItem.yLabel;
            }
          }
        }
      }
    })


    // 기간별 우편발송 현황 데이터 우측
    let sendCnt2 = sendData.list.map(data => data.allCnt)
    let labels2 = sendData.list.map(data => data.regDt)

    if (state.setting.sendLookupRange === 'year' && labels2.length) {
      labels2.unshift(labels2[0].replace('년', '') * 1 - 1 + '년')
      sendCnt2.unshift(0)
    }

    charts.send[1] = new Chart(dateBySendCanvas.current.getContext('2d'), {
      type: 'line',
      data: {
        labels: labels2,
        datasets: [{
          label: "발송현황 추이",
          backgroundColor: 'rgba(255,85,74,0.5)',
          borderColor: 'rgba(255,85,74,1)',
          minBarLength: 2,
          data: sendCnt2
        }]
      },
      options: {
        scales: {
          yAxes: [{
            ticks: {
              min: 0,
              beginAtZero: true
            }
          }]
        },
        legend: {
          display: false
        },
        tooltips: {
          callbacks: {
            label: function(tooltipItem) {
              return tooltipItem.yLabel;
            }
          }
        }
      }
    })
  }, [state.value.sendData])

  useEffect(() => {
    if (state.setting.agency)
      setFormatData(state.setting.agency);

  }, [state.setting.agency])

  useEffect(() => {
    charts.receive.forEach(chart => chart.destroy());

    charts.receive[0] = new Chart(typeByCanvas.current.getContext('2d'), {
      type: 'doughnut',
      data: {
        labels: receiveLookupDataLabel,
        datasets: [{
          data: receiveLookupData,
          backgroundColor: [
            '#ff554a',
            '#f5b53e',
            '#5b9494',
            '#143761',
          ]
        }],
      }
    })
  }, [state.value.receiveData, state.setting.receiveLookupRange])

  useEffect(() => {
    if (localStorage.getItem('type') !== 'system') return
    
    const { signUpData } = state.value;

    new Chart(dateBySignUpCanvas.current.getContext('2d'), {
      type: 'line',
      data: {
        labels: signUpData.list.map(data => data.regDt),
        datasets: [{
          label: '기간별 회원가입 현황',
          data: signUpData.list.map(data => data.allCnt),
          borderColor: "rgba(255,85,74,1)",
          backgroundColor: "rgba(255,85,74,0.5)",
          fill: true,
          lineTension: 0
        }]
      },
    })
  }, [state.value.signUpData])

  useEffect(() => {
    if (localStorage.getItem('type') !== 'system') return

    const { dayBySignUpData } = state.value;

    charts.dayBySignUp.map(chart => chart.destroy())

    charts.dayBySignUp[0] = new Chart(signUpCanvas.current.getContext('2d'), {
      type: 'line',
      data: {
        labels: dayBySignUpData.list.map(data => data.regDt),
        datasets: [{
          label: '회원가입 현황',
          data: dayBySignUpData.list.map(data => data.allCnt),
          borderColor: "rgba(255,85,74,1)",
          backgroundColor: "transparent",
          fill: true,
          lineTension: 0
        }]
      },
    })
  }, [state.value.dayBySignUpData])

  const getStartDate = (group) => {
    const date = state.setting.stardendDate;
    switch (group) {
      case 'day':
        return format(subDays(date, 8), 'yyyy-M-d');
      case 'week':
        return format(subWeeks(date, 8), 'yyyy-M-d');
      case 'month':
        return format(subMonths(date, 8), 'yyyy-M-d');
      case 'year':
        return format(subYears(date, 8), 'yyyy-M-d');
      default:
        return format(subDays(date, 8), 'yyyy-M-d');
    }
  }

  const setSendData = async (group = "day") => {
    let response = await Api.getSendData({
      startDate: getStartDate(group),
      endDate: format(state.setting.stardendDate, 'yyyy-M-d'),
      group: group,
      org_code: state.setting.agency ? state.setting.agency.org_code : 'all',
      dept_code: state.setting.agency ? state.setting.agency.dept_code : 'all',
      template: state.setting.format ? state.setting.format.file_name : 'all'
    });

    setState(produce(draftState => {
      draftState.value.sendData = response.reduce((acc, data) => ({
        totalAPPCnt: acc.totalAPPCnt + data.totalAPPCnt,
        totalDMCnt: acc.totalDMCnt + data.totalDMCnt,
        totalMMSCnt: acc.totalMMSCnt + data.totalMMSCnt,
        allCnt: acc.allCnt + data.allCnt,
        list: [...acc.list, data],
      }), {
        totalAPPCnt: 0,
        totalDMCnt: 0,
        totalMMSCnt: 0,
        allCnt: 0,
        list: [],
      });

      draftState.setting.sendLookupRange = group;
    }))
  }

  const setReceiveData = async () => {
    const response = await Api.getReceiveData({
      endDate: format(state.setting.stardendDate, 'yyyy-M-d'),
      org_code: state.setting.agency ? state.setting.agency.org_code : 'all',
      dept_code: state.setting.agency ? state.setting.agency.dept_code : 'all',
      template: state.setting.format ? state.setting.format.file_name : 'all'
    });

    setState(produce(draftState => {
      draftState.value.receiveData = response;
    }))
  }

  const setSignUpData = async (group = "week") => {
    const response = await Api.getSignUpData({
      startDate: getStartDate(group),
      endDate: format(state.setting.stardendDate, 'yyyy-M-d'),
      group: group
    });

    setState(produce(draftState => {
      draftState.value.signUpData = response.reduce((acc, data) => ({
        allCnt: acc.allCnt + data.allCnt,
        list: [...acc.list, data],
      }), {
        allCnt: 0,
        list: [],
      });

      draftState.setting.signUpLookupRange = group;
    }))
  }

  const setDayBySignUpData = async (date = new Date()) => {
    const response = await Api.getSignUpData({
      startDate: format(subDays(date, 7), 'yyyy-M-d'),
      endDate: format(date, 'yyyy-M-d'),
      group: 'day'
    });

    const dataList = Array(7).fill(0)
      .reduce((acc, next) => (
        [...acc, addDays(acc[acc.length - 1], 1)]
      ), [subDays(date, 7)])
      .map((date) => {
        const formatDate = format(date, 'yyyy-M-dd')
        const responseData = response.find(data => data.regDt === formatDate);

        return {
          regDt: formatDate,
          allCnt: responseData ? responseData.allCnt : 0
        }
      })

    setState(produce(draftState => {
      draftState.value.dayBySignUpData = dataList.reduce((acc, data) => ({
        allCnt: acc.allCnt + data.allCnt,
        list: [...acc.list, data],
      }), {
        allCnt: 0,
        list: [],
      });
      
      draftState.setting.signUpDate = date;
    }))
  }

  const setAgencyData = async () => {
    const response = await Api.getOrgs()

    setState(produce(draftState => {
      draftState.value.agencyData = response;
    }))
  }

  const setFormatData = async () => {
    if (state.setting.agency.idx) {
      const response = await Api.getFormats(state.setting.agency.idx);

      setState(produce(draftState => {
        draftState.value.formatData = response;
      }))
    } else {
      setState(produce(draftState => {
        draftState.value.formatData = [];
      }))
    }
  }

  const handleLookupRangeChange = (key, value) => {
    switch (key) {
      case 'sendLookupRange':
        setSendData(value);
        break;
      case 'signUpLookupRange':
        setSignUpData(value);
        break;
      default:
        setState(produce(draftState => {
          draftState.setting[key] = value;
        }))
        break;
    }
  }
  
  const handlePopupToggle = (name, visible) => {
    setState(produce(draftState => {
      draftState.popup[name] = visible
    }))
  }

  return (
    <>
      <DefaultTemplate>
        <Box display="flex" alignItems="center" justifyContent="flex-end">
          <Typography variant="h6">현재 {format(state.setting.stardendDate, 'yyyy년 M월 dd일 HH시 mm분')} </Typography>
          <IconButton
            color="primary"
            onClick={() => {
              setState(produce(draftState => {
                draftState.setting.stardendDate = new Date();
              }))
            }}
          ><Icon>refresh</Icon></IconButton>
        </Box>

        <Box marginY={3}>
          <Paper>
            <Box padding={3}>
              <Grid container spacing={3} alignItems="center">
                <Grid item xs={1}>기관선택</Grid>
                <Grid item xs={3}>
                  <TextField
                    value={state.setting.agency ? `${state.setting.agency.org_name} ${state.setting.agency.dept_name}` : '전체'}
                    fullWidth
                    readonly
                  />
                </Grid>
                <Grid item xs={1}>
                  <Button
                    fullWidth
                    variant="contained"
                    color="primary"
                    onClick={() => handlePopupToggle('agency', true)}
                  >기관선택</Button>
                </Grid>
                <Grid item xs={1}></Grid>
                <Grid item xs={1}>서식이름</Grid>
                <Grid item xs={3}>
                  <TextField
                    value={state.setting.format ? state.setting.format.template_name : '전체'}
                    fullWidth
                    readonly
                  />
                </Grid>
                <Grid item xs={1}>
                  <Button
                    fullWidth
                    variant="contained"
                    color="primary"
                    onClick={() => handlePopupToggle('format', true)}
                  >서식선택</Button>
                </Grid>
              </Grid>
            </Box>
          </Paper>
        </Box>

        <Grid container spacing={3}>
        <Grid item xs={12}>
            <DashBoardTitle
              title="우편 발송 현황"
              buttons={[
                {
                  label: '총 현황',
                  value: 'total'
                },
                {
                  label: '모바일우편',
                  value: 'app'
                },
                {
                  label: '문자우편',
                  value: 'mms'
                },
                {
                  label: '종이우편',
                  value: 'dm'
                },
                {
                  label: '차단',
                  value: 'deny'
                },
                {
                  label: 'DM 연계 발송',
                  value: 'dmLink'
                },
                {
                  label: '실패',
                  value: 'fail'
                }
              ]}
              active={state.setting.receiveLookupRange}
              onButtonClick={(value) => {
                handleLookupRangeChange('receiveLookupRange', value);
              }}
            />
            <Grid container spacing={3}>
              <Grid item xs={6}>
                <Paper className={classes.root}>
                  <canvas ref={typeByCanvas}></canvas>
                </Paper>
              </Grid>
              <Grid item xs={6}>
                <Paper className={clsx(classes.root, 'height-100')}>
                  <Grid container spacing={2} alignItems="center" className="height-100">
                    {
                      receiveLookupDataLabel.map((label, i) => (
                        <Grid item xs={12 / receiveLookupDataLabel.length}>
                          <StatusColumn
                            title={label}
                            content={(receiveLookupData[i] / receiveLookupDataTotal * 100) || '0'}
                            footer={number.format(receiveLookupData[i])}
                            nonBorder={i === receiveLookupDataLabel.length - 1}
                          />
                        </Grid>
                      ))
                    }
                  </Grid>
                </Paper>
              </Grid>
            </Grid>
          </Grid>


          <Grid item xs={12}>
            <DashBoardTitle
              title="기간별 우편발송 현황"
              buttons={[
                {
                  label: '일일 현황',
                  value: 'day'
                },
                {
                  label: '주간 현황',
                  value: 'week'
                },
                {
                  label: '월간 현황',
                  value: 'month'
                },
                {
                  label: '연간 현황',
                  value: 'year'
                },
              ]}
              active={state.setting.sendLookupRange}
              onButtonClick={(value) => {
                handleLookupRangeChange('sendLookupRange', value);
              }}
            />
            <Grid container spacing={3} alignItems="stretch">
              <Grid item xs={7}>
                <Paper className={classes.root}>
                  <canvas ref={dateByTypeCanvas}></canvas>
                </Paper>
              </Grid>
              <Grid item xs={3}>
                <Paper className={clsx(classes.root, 'height-100')}>
                  <ul className="main-list">
                    <li className="main-list__item main-list__item--primary" style={{borderBottom: '1px solid rgba(0,0,0,.1)', paddingBottom: '27px'}}>
                      <span className="main-list__item-name"></span>
                      <span className="main-list__item-value">평균</span>
                    </li>
                    <li className="main-list__item" style={{borderBottom: '1px solid rgba(0,0,0,.1)', paddingBottom: '27px'}}>
                      <span className="main-list__item-name">모바일우편</span>
                      <span className="main-list__item-value">
                        {number.format(Math.round(sendData.totalAPPCnt / sendData.list.filter(v => v.totalAPPCnt).length) || 0)}
                      </span>
                    </li>
                    <li className="main-list__item" style={{borderBottom: '1px solid rgba(0,0,0,.1)', paddingBottom: '27px'}}>
                      <span className="main-list__item-name">문자우편</span>
                      <span className="main-list__item-value">
                        {number.format(Math.round(sendData.totalMMSCnt / sendData.list.filter(v => v.totalAPPCnt).length) || 0)}
                        {/* {number.format(Math.round(sendData.totalMMSCnt / sendData.list.length))} */}
                      </span>
                    </li>
                    <li className="main-list__item">
                      <span className="main-list__item-name">종이우편</span>
                      <span className="main-list__item-value">
                        {number.format(Math.round(sendData.totalDMCnt / sendData.list.filter(v => v.totalDMCnt).length) || 0)}
                        {/* {number.format(Math.round(sendData.totalDMCnt / sendData.list.length))} */}
                      </span>
                    </li> 
                  </ul>
                </Paper>
              </Grid>
            </Grid>


            <Grid container spacing={3} alignItems="stretch">
              <Grid item xs={3}>
                <Paper className={clsx(classes.root, 'height-100')}>
                  <ul className="main-list">
                    <li className="main-list__item" style={{borderBottom: '1px solid rgba(0,0,0,.1)', paddingBottom: '27px'}}>
                      <span className="main-list__item-name">모바일우편</span>
                      <span className="main-list__item-value">{number.format(sendData.totalAPPCnt)}</span>
                    </li>
                    <li className="main-list__item" style={{borderBottom: '1px solid rgba(0,0,0,.1)', paddingBottom: '27px'}}>
                      <span className="main-list__item-name">문자우편</span>
                      <span className="main-list__item-value">{number.format(sendData.totalMMSCnt)}</span>
                    </li>
                    <li className="main-list__item" style={{borderBottom: '1px solid rgba(0,0,0,.1)', paddingBottom: '27px'}}>
                      <span className="main-list__item-name">종이우편</span>
                      <span className="main-list__item-value">{number.format(sendData.totalDMCnt)}</span>
                    </li>
                    <li className="main-list__item main-list__item--primary" style={{borderBottom: '1px solid rgba(0,0,0,.1)', paddingBottom: '27px'}}>
                      <span className="main-list__item-name">Total</span>
                      <span className="main-list__item-value">{number.format(sendData.allCnt)}</span>
                    </li>
                    {
                      sendData.list.length >= 2 &&
                      <li className="main-list__item" style={{justifyContent: 'flex-end', textAlign: 'right'}}>
                          {beforeLabel[state.setting.sendLookupRange]}대비<br />
                          {number.format(Math.abs(beforeSendDataGap))}건 {beforeSendDataGap >= 0 ? '증가' : '감소'}
                      </li>
                    }
                  </ul>
                </Paper>
              </Grid>
              <Grid item xs={7}>
                <Paper className={classes.root}>
                  <canvas ref={dateBySendCanvas}></canvas>
                </Paper>
              </Grid>
            </Grid>
          </Grid>

          {localStorage.getItem('type') === 'system' && (
            <Grid item xs={12}>
              <DashBoardTitle
                title="회원가입 현황"
              />
              <Grid container spacing={3} alignItems="stretch">
                <Grid item xs={5}>
                  <Paper className={clsx(classes.root, 'height-100')}>
                    <Box display="flex" flexDirection="column" height="100%">
                      <Box display="flex" justifyContent="space-between" alignItems="center">
                        <Button variant="contained" color="primary" onClick={() => {
                          setDayBySignUpData(subDays(state.setting.signUpDate, 1));
                        }}>
                          <ArrowBackIcon />
                        </Button>
                        <Typography variant="h6" component="div">{format(state.setting.signUpDate, 'yyyy년 M월 dd일')}</Typography>
                        <Button variant="contained" color="primary" onClick={() => {
                          setDayBySignUpData(addDays(state.setting.signUpDate, 1));
                        }}>
                          <ArrowForwardIcon />
                        </Button>
                      </Box>
                      <Box flex="1" justifyContent="center" display="flex" flexDirection="column">
                        <canvas ref={signUpCanvas}></canvas>
                        <Grid container spacing={0}>
                          <Grid item xs={6}>
                            <StatusBox
                              bgcolor={'#5b9494'}
                              color="#ffffff"
                              label="오늘"
                              value={!!dayBySignUpData.list.length && number.format(dayBySignUpData.list[dayBySignUpData.list.length - 1].allCnt)}
                            />
                          </Grid>
                          <Grid item xs={6}>
                            <StatusBox
                              bgcolor={'#143761'}
                              color="#ffffff"
                              label="누적"
                              value={number.format(dayBySignUpData.list.reduce((acc, next) => acc + next.allCnt, 0))}
                            />
                          </Grid>
                        </Grid>
                      </Box>
                    </Box>
                  </Paper>
                </Grid>
                <Grid item xs={7}>
                  <Paper className={classes.root}>
                    <ButtonGroup color="primary" size="large">
                      {[
                        {
                          label: '주간 현황',
                          value: 'week'
                        },
                        {
                          label: '월간 현황',
                          value: 'month'
                        },
                        {
                          label: '연간 현황',
                          value: 'year'
                        },
                      ].map(button => (
                        <Button
                          variant={state.setting.signUpLookupRange === button.value ? 'contained' : ''}
                          key={button.value}
                          onClick={_ => handleLookupRangeChange('signUpLookupRange', button.value)}
                        >{button.label}</Button>
                      ))}
                    </ButtonGroup>
                    <canvas ref={dateBySignUpCanvas}></canvas>
                  </Paper>
                </Grid>
              </Grid>
            </Grid>
          )}
        </Grid>
      </DefaultTemplate>

      <Dialog open={state.popup.agency} onClose={() => handlePopupToggle('agency', false)} >
        <DialogTitle>기관선택</DialogTitle>
        <DialogContent>
          <DialogContentText>
            조회하실 기관을 선택해주세요. 아무것도 선택 안되있을시 전체가 표시됩니다.
          </DialogContentText>
          <table className="c-table">
            <thead>
              <th>기관 코드</th>
              <th>이름</th>
              <th>부서</th>
              <th>선택</th>
            </thead>
            <tbody>
              {state.value.agencyData.map(data => {
              
              return (
                <tr key={data.idx}>
                  <td>{data.org_code}</td>
                  <td>{data.org_name}</td>
                  <td>{data.dept_name}</td>
                  <td>
                    <Checkbox
                      color="primary"
                      name="aaaa"
                      checked={Boolean(state.setting.agency && data.idx === state.setting.agency.idx)}
                      value={data.idx}
                      onChange={e => {
                        setState(produce(draftState => {
                          draftState.setting.agency = e.target.checked ? data : null;
                        }))
                      }}
                    />
                  </td>
                </tr>
              )})}
            </tbody>
          </table>
        </DialogContent>
        <DialogActions>
          <Button color="primary" onClick={() => handlePopupToggle('agency', false)}>
            완료
          </Button>
        </DialogActions>
      </Dialog>

      <Dialog open={state.popup.format} onClose={() => handlePopupToggle('format', false)} >
        <DialogTitle>서식선택</DialogTitle>
        <DialogContent>
          <DialogContentText>
            조회하실 서식을 선택해주세요. 아무것도 선택 안되있을시 전체가 표시됩니다.
          </DialogContentText>
          <table className="c-table">
            <thead>
              <th>이름</th>
              <th>선택</th>
            </thead>
            <tbody>
              {state.value.formatData.map(data => (
                <tr>
                  <td>{data.template_name}</td>
                  <td>
                    <Checkbox
                      color="primary"
                      name="bbbb"
                      checked={Boolean(state.setting.format && data.idx === state.setting.format.idx)}
                      onChange={e => {
                        setState(produce(draftState => {
                          draftState.setting.format = e.target.checked ? data : null;
                          setSendData(state.setting.sendLookupRange)
                        }))
                      }}
                    />
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </DialogContent>
        <DialogActions>
          <Button color="primary" onClick={() => handlePopupToggle('format', false)}>
            완료
          </Button>
        </DialogActions>
      </Dialog>
    </>
  )
}

export default Index