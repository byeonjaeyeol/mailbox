const express = require('express')
const multer = require('multer')
const auth = require('../helpers/auth')
const crypto = require('../helpers/crypto')
const { match } = require('path-to-regexp')
const { oneQuery, file } = require('../helpers/mysql')
const request = require('request-promise')
const parseString = require('xml2js').parseString

const router = express.Router()
const uploadMW = multer({ dest: 'upload' })
const unAuthAPIs = ['/signIn', { method: 'GET', path: '/upload' }, { method: 'GET', path: '/notice' }]


// API 경로 접근 허용 및 Token 검사
router.all('*', function(req, res, next) {
  res.header('Access-Control-Allow-Origin', '*')
  res.header('Access-Control-Allow-Methods', '*')
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization')

  // 옵션 메소드라면 Token 검사 안하고 넘김
  if (req.method === 'OPTIONS')
    return next()

  const isUnAuthAPI = unAuthAPIs.some(route => {
    if (typeof route === 'object') {
      return route.method.toUpperCase() === req.method && Boolean(match(`${route.path}(/.*)?`)(req.path))
    } else {
      return !!match(`${route}(/.*)?`)(req.path)
    }
  })
  const token = req.headers.hasOwnProperty('authorization') ? req.headers.authorization.replace(/^Bearer /i, '') : null
  req.user = token && auth.verify(token)

  // 토근 검사
  if (!isUnAuthAPI && !req.user)
    return res.status(401).send(token ? 'Invalid token' : 'Token not found')

  next()
})


// 로그인 처리
router.post('/signIn', async (req, res) => {
  const data = req.body
  let user = {}

  const [system] = await oneQuery(`SELECT * FROM TBL_SYSTEM_USER WHERE user = ?`, [data.id])

  if (system) {
    user = {
      ...system,
      type: 'system'
    }
  } else {
    const [org] = await oneQuery(`SELECT * FROM TBL_AGENCY_USER WHERE user = ?`, [data.id])

    if (!org)
      return res.status(401).send('아이디 또는 비밀번호가 일치하지 않습니다')

    user = {
      ...org,
      type: 'org'
    }
  }

  if (!await crypto.verify(user.password, user.salt, data.password)) {
    return res.status(401).send('아이디 또는 비밀번호가 일치하지 않습니다')
  }

  delete user.salt
  delete user.password

  const token = auth.sign(user)
  await oneQuery(`INSERT INTO TBL_CONNECTION SET ?`, {
    user_id: user.id,
    user_type: user.type,
    ip: req.headers['x-forwarded-for'] || req.connection.remoteAddress || req.socket.remoteAddress || req.connection.socket.remoteAddress
  })

  res.json({
    token,
    type: user.type,
    id: user.id,
    ...user
  })
})


// 접속 이력 가져오기
router.get('/connection/:type', async (req, res) => {
  const { type } = req.params
  const tables = {
    system: 'TBL_SYSTEM_USER',
    org: 'TBL_AGENCY_USER'
  }

  // let sql = `
  //   SELECT
  //     c.datetime,
  //     c.ip,
  //     u.user
  //   FROM TBL_CONNECTION as c
  //   LEFT JOIN ?? as u
  //   ON u.id = c.user_id
  //   WHERE c.user_type = ?
  //   ORDER BY datetime DESC
  // `
  let values = [tables[type], type]


  if (req.user.type === 'org') {
    //sql += ' && u.org_name = ? && u.dept_name = ?'
    var sql = `
    SELECT
      c.datetime,
      c.ip,
      u.user
    FROM TBL_CONNECTION as c
    LEFT JOIN ?? as u
    ON u.id = c.user_id
    WHERE c.user_type = ? AND u.org_name = ?
    ORDER BY datetime DESC
  `

    values.push(req.user.org_name)
   // values.push(req.user.dept_name)
  } else{
    var sql = `
    SELECT
      c.datetime,
      c.ip,
      u.user
    FROM TBL_CONNECTION as c
    LEFT JOIN ?? as u
    ON u.id = c.user_id
    WHERE c.user_type = ?
    ORDER BY datetime DESC
  `

  }

  const historys = await oneQuery(sql, values)

  res.json(historys)
})


// 업로드 파일 가져오기
router.get('/upload/:id', async (req, res) => {
  const row = await file.get(req.params.id)
  
  if (row) {
    res.sendFile(`${global.uploadDir}/${row.filename}`)
  } else {
    res.status(404).send('존재하지 않는 파일입니다')
  }
})


// 업로드 파일 다운로드 하기
router.get('/upload/:id/download', async (req, res) => {
  const row = await file.get(req.params.id)

  if (row) {
    res.download(`${global.uploadDir}/${row.filename}`, row.origin_filename)
  } else {
    res.status(404).send('존재하지 않는 파일입니다')
  }
})


// 우편 발송 현황 가져오기
router.get('/mail/send', async (req, res) => { 
  const { startDate, endDate, group, org_code, dept_code, template } = req.query
  let groupBy = "DATE_FORMAT(`reg_dt`, '%Y-%m-%d')"
  let sql = ''
  let where = '';
  let values = []

  switch (group) {
    case 'week':
      groupBy = "CONCAT(DATE_FORMAT(`reg_dt`, '%Y년 %c월 '), WEEK(`reg_dt`) - WEEK(DATE_FORMAT(`reg_dt`, '%Y-%c-01')) + 1, '주')"
    break

    case 'month':
      groupBy = "CONCAT(YEAR(`reg_dt`), '년 ', MONTH(`reg_dt`), '월')"
    break

    case 'year':
      groupBy = "CONCAT(YEAR(`reg_dt`), '년')"
    break
  }

  sql = `
    SELECT
      SUM(done_app_cnt) as totalAPPCnt,
      SUM(done_mms_cnt) as totalMMSCnt,
      SUM(done_dm_cnt) + SUM(done_deny_cnt) as totalDMCnt,
      SUM(done_app_cnt) + SUM(done_mms_cnt) + SUM(done_dm_cnt) + SUM(done_deny_cnt) as allCnt,
      ${groupBy} as regDt
    FROM
      TBL_STAT_DISPRESULT as s
  `
  //kimcy :except admin
  if (req.user.type === 'org' && req.user.authority !== 'admin') {
    sql += `
      INNER JOIN TBL_AGENCY as o
      ON
        o.org_code = s.org_code
        && o.dept_code = s.dept_code
        && o.org_name = ?
        && o.dept_name = ?
    `
    values.push(req.user.org_name)
    values.push(req.user.dept_name)
  }

  sql += `
    WHERE
      reg_dt >= ? &&
      reg_dt <= ? &&
      ${org_code !== 'all' ? `s.org_code = '${org_code}'` : '1'} &&
      ${dept_code !== 'all' ? `s.dept_code = '${dept_code}'` : '1'} &&
      ${template !== 'all' ? `s.template = '${template}'` : '1'}
    GROUP BY
      regDt
  `

  values.push(startDate)
  values.push(endDate)

  const results = await oneQuery(sql, values)

  res.json(results)
})


// 우편 수신 현황 가져오기
router.get('/mail/receive', async (req, res) => {
  const { startDate, endDate, group, org_code, dept_code, template } = req.query
  let sql = `
    SELECT
      SUM(failed_cnt) as failCnt,
      SUM(failed_deny_cnt) as failedDenyCnt,
      SUM(failed_retry_cnt) as failedRetryCnt,

      SUM(done_app_cnt) as doneAPPCnt,

      SUM(done_dm_cnt) as doneDMCnt,
      SUM(disp_dm_cnt) as dispDMCnt,
      SUM(ing_dm_cnt) as ingDMCnt,

      SUM(done_mms_cnt) as doneMMSCnt,
      SUM(ing_mms_cnt) as ingMMSCnt,
      SUM(disp_mms_cnt) as dispMMSCnt,
      SUM(result_mms_suc_cnt) as resultMMSSucCnt,
      SUM(result_mms_fail_cnt) as resultMMSFailCnt,
      SUM(retry_mms_dm_cnt) as retryMMSDmCnt,

      SUM(done_deny_cnt) as doneDenyCnt,
      SUM(ing_deny_cnt) as ingDenyCnt,
      SUM(disp_deny_cnt) as dispDenyCnt
    FROM
      TBL_STAT_DISPRESULT as s
  `
  let values = []

  //kimcy except admin
  if (req.user.type === 'org' && req.user.authority !== 'admin') {
    sql += `
      INNER JOIN TBL_AGENCY as o
      ON
        o.org_code = s.org_code
        && o.dept_code = s.dept_code
        && o.org_name = ?
        && o.dept_name = ?
    `
    values.push(req.user.org_name)
    values.push(req.user.dept_name)
  }

  sql += `
    WHERE
    ${org_code !== 'all' ? `s.org_code = '${org_code}'` : '1'} &&
    ${dept_code !== 'all' ? `s.dept_code = '${dept_code}'` : '1'} &&
    ${template !== 'all' ? `s.template = '${template}'` : '1'}
  `

  const results = await oneQuery(sql, values)

  res.json(results[0])
})


// 회원가입 현황
router.get('/member/stats', async (req, res) => { 
	const { startDate, endDate, group } = req.query;
	let groupBy = "DATE_FORMAT(`reg_dt`, '%Y-%m-%d')";

	switch (group) {
		case 'week':
			groupBy = "CONCAT(DATE_FORMAT(`reg_dt`, '%Y년 %c월 '), WEEK(`reg_dt`) - WEEK(DATE_FORMAT(`reg_dt`, '%Y-%c-01')) + 1, '주')";
			break;
		case 'month':
			groupBy = "CONCAT(MONTH(`reg_dt`), '월')";
			break;
		case 'year':
			groupBy = "CONCAT(YEAR(`reg_dt`), '년')";
			break;
  }
  
  const results = await oneQuery(`
    SELECT
      COUNT(idx) as allCnt,
      ${groupBy} as regDt
    FROM
      TBL_PCODE
    WHERE
      reg_dt >= '${startDate}' && reg_dt <= '${endDate}' &&
      member_yn = 'Y'
    GROUP BY
      regDt
    ORDER BY
      regDt DESC
  `)

  res.json(results)
})


// 회원 통계
router.get('/member/stats/day', async (req, res) => { 
	const { startDate, endDate } = req.query
  
  const joinRows = await oneQuery(`
    SELECT
      COUNT(*) as count,
      entry_dt as date
    FROM
      TBL_EPOSTMEMBER
    WHERE
      entry_dt >= ? && entry_dt <= ?
    GROUP BY
      date
    ORDER BY
      entry_dt DESC
  `, [startDate, endDate])

  const exitRows = await oneQuery(`
    SELECT
      COUNT(*) as count,
      withdr_dt as date
    FROM
      TBL_EPOSTMEMBER
    WHERE
      withdr_dt >= ? && withdr_dt <= ?
    GROUP BY
      date
    ORDER BY
      withdr_dt DESC
  `, [startDate, endDate])

  const guestRows = await oneQuery(`
    SELECT
      COUNT(*) as count,
      reg_dt as date
    FROM
      TBL_PCODE
    WHERE
      member_yn = 'N' && reg_dt >= ? && reg_dt <= ?
    GROUP BY
      date
    ORDER BY
      reg_dt DESC
  `, [startDate, endDate])


  const end_dt = new Date(endDate)
  let i = new Date(startDate)
  let result = []

  // i가 종료일보다 작다면 반복
  while (i <= end_dt) {
    const date = i.toISOString().split('T')[0]
    const joinCount = joinRows.filter(row => row.date.toISOString().split('T')[0] === date).reduce((acc, row) => acc + Number(row.count), 0)
    const exitCount = exitRows.filter(row => row.date.toISOString().split('T')[0] === date).reduce((acc, row) => acc + Number(row.count), 0)
    const guestCount = guestRows.filter(row => row.date.toISOString().split('T')[0] === date).reduce((acc, row) => acc + Number(row.count), 0)

    result.push({
      date,
      join: joinCount,
      exit: exitCount,
      guest: guestCount,
    })

    // 날짜 + 1
    i.setDate(i.getDate() + 1)
  }

  result.reverse()

  res.json(result)
})


// 우편물 발송 조회
router.get('/post/send', async (req, res) => {
  let sql = `
    SELECT *
    FROM
      TBL_DOCUMENTS AS doc,
      TBL_AGENCY AS org,
      TBL_PCODE as pcode
    WHERE
      doc.agency_id = org.idx
      && doc.p_code_idx = pcode.idx
  `
  let values = []

  if (req.user.type === 'org') {
    sql += ' && org.org_name = ? && org.dept_name = ?'
    values.push(req.user.org_name)
    values.push(req.user.dept_name)
  }

  const results = await oneQuery(sql, values)

  res.json(results)
})


// 우편물 발송 통계
router.get('/post/statistics', async (req, res) => {
  let sql = `
    SELECT
      *
    FROM
      TBL_STAT_DISPRESULT AS stat
    LEFT JOIN
      TBL_AGENCY AS org
    ON
      stat.org_code = org.org_code
  `
  let values = []

  //kimcy add
  if(req.user.type === 'org' && req.user.authority === 'admin'){
    sql += 'WHERE org.org_name = ?'
    values.push(req.user.org_name)
  }
  else if (req.user.type === 'org') {
    sql += 'WHERE org.org_name = ? && org.dept_name = ?'
    values.push(req.user.org_name)
    values.push(req.user.dept_name)
  }

  sql += `
    ORDER BY
      reg_dt DESC
  `

  const results = await oneQuery(sql, values)

  res.json(results)
})


// 계정 아이디가 있는지 확인
router.get('/account/exist/:id', async (req, res) => {
  const { id } = req.params

  const res1 = await oneQuery(`SELECT id FROM TBL_SYSTEM_USER WHERE user = ?`, [id])
  const res2 = await oneQuery(`SELECT id FROM TBL_AGENCY_USER WHERE user = ?`, [id])

  res.send(!!res1.length || !!res2.length)
})


// 계정 정보 가져오기
router.get('/account/:category', async (req, res) => {
  const { category } = req.params
  let { page, pageSize, keywords } = req.query
  keywords = keywords ? JSON.parse(keywords) : []
  let totalCount = 0
  let sql = ''
  let values = []

  let search = keywords.map(v => `${v.field} LIKE '%${v.keyword}%'`).join(' && ')

  switch (category) {
    case 'system':
      sql = `
        SELECT
          id,
          user,
          manager,
          contact,
          email,
          authority
        FROM TBL_SYSTEM_USER
      `
    break

    case 'org':
      sql = `
        SELECT
          id,
          org_name,
          dept_name,
          user,
          manager,
          contact,
          email,
          authority
        FROM TBL_AGENCY_USER
      `
    break
    
    case 'member' :
      sql = `
        SELECT
          hp,
          name,
          p_code,
          entry_dt,
          uuid
        FROM
          TBL_EPOSTMEMBER
        ${search ? `WHERE ${search}` : ''}
        ORDER BY
          name ASC
      `

      const [{ count }] = await oneQuery(`
        SELECT
          COUNT(*) as count
        FROM
          TBL_EPOSTMEMBER as m
      `)

      totalCount = count
    break
  }

  if (req.user.type === 'org') {
    sql += ' WHERE org_name = ? && dept_name = ?'
    values.push(req.user.org_name)
    values.push(req.user.dept_name)
  }

  if (category === 'member') {
    sql += ' LIMIT ?, ?'
    values.push(Number(page) * Number(pageSize))
    values.push(Number(pageSize))
  }

  const results = await oneQuery(sql, values)

  if (category === 'member') {
    res.json({
      totalCount,
      items: results
    })
  } else {
    res.json(results)
  }
})


// 계정 정보 하나만 가져오기
router.get('/account/:category/:id', async (req, res) => {
  const tables = { system: 'SYSTEM', org: 'AGENCY' }
  const { category, id } = req.params
  let sql = ''
  let values = []

  switch (category) {
    case 'system':
      sql = `
        SELECT
          id,
          user,
          manager,
          contact,
          email,
          authority
        FROM TBL_SYSTEM_USER
        WHERE id = ?
      `
      values.push(id)
    break

    case 'org':
      sql = `
        SELECT
          id,
          org_name,
          dept_name,
          user,
          manager,
          contact,
          email,
          authority
        FROM TBL_AGENCY_USER
        WHERE id = ?
      `
      values.push(id)
    break

    case 'member':
      sql = `
        SELECT
          m.hp,
          m.name,
          m.p_code,
          m.password,
          m.entry_dt,
          m.birth,
          m.uuid,
          a.addr1,
          a.addr2,
          c.car_num
        FROM
          TBL_EPOSTMEMBER as m
        LEFT JOIN
          TBL_MEMBERADDRESS as a
        ON
          a.p_code = m.p_code
        LEFT JOIN
          TBL_MEMBERCAR as c
        ON
          c.p_code = m.p_code
        WHERE
          m.uuid = ?
      `
      values.push(id)
    break
  }

  const results = await oneQuery(sql, values)

  res.json(results)
})


// 계정 정보 추가하기
router.post('/account/:category', async (req, res) => {
  const tables = { system: 'SYSTEM', org: 'AGENCY' }
  const { category } = req.params
  let data = req.body

  const [password, salt] = await crypto.encrypt(data.password)

  data.password = password
  data.salt = salt

  await oneQuery(`INSERT INTO ?? SET ?`, [
    `TBL_${tables[category]}_USER`,
    data
  ])

  res.send('ok')
})


// 계정 정보 수정하기
router.put('/account/:category/:id', async (req, res) => {
  const tables = { system: 'SYSTEM', org: 'AGENCY' }
  const { category, id } = req.params
  const data = req.body

  if (data.password) {
    const [password, salt] = await crypto.encrypt(data.password)

    data.password = password
    data.salt = salt
  }

  await oneQuery(`UPDATE ?? SET ? WHERE id = ?`, [
    `TBL_${tables[category]}_USER`,
    data,
    id
  ])

  res.send('ok')
})


// 비밀번호 수정하기
router.put('/password/:id', async (req, res) => {
  const tables = { system: 'SYSTEM', org: 'AGENCY' }
  const { id } = req.params
  const data = req.body


  const [ user ] = await oneQuery(`SELECT password, salt FROM ?? WHERE id = ?`, [
    `TBL_${tables[req.user.type]}_USER`,
    id
  ])

  if (!user || !await crypto.verify(user.password, user.salt, data.nowPassword)) {
    return res.status(400).send('현재 비밀번호가 일치하지 않습니다')
  }

  const [password, salt] = await crypto.encrypt(data.newPassword)
  const updateData = { password, salt }

  await oneQuery(`UPDATE ?? SET ? WHERE id = ?`, [
    `TBL_${tables[req.user.type]}_USER`,
    updateData,
    id
  ])

  res.send('ok')
})


// 계정 정보 삭제하기
router.delete('/account/:category/:id', async (req, res) => {
  const tables = { system: 'SYSTEM', org: 'AGENCY' }
  const { category, id } = req.params

  await oneQuery(`DELETE FROM TBL_CONNECTION WHERE user_id = ? && user_type = ?`, [
    id,
    category
  ])

  await oneQuery(`DELETE FROM ?? WHERE id = ?`, [
    `TBL_${tables[category]}_USER`,
    id
  ])

  res.send('ok')
})


// 부서 코드 중복 확인
router.get('/org/dept/exist/:dept_code', async (req, res) => {
  const { dept_code } = req.params

  const [{ count }] = await oneQuery(`SELECT COUNT(*) as count FROM TBL_AGENCY WHERE dept_code = ?`, [dept_code])

  res.json(Boolean(count))
})


// 기관, 부서 전부 가져오기
router.get('/org/dept', async (req, res) => {
  let sql = `SELECT org_code, org_name, dept_code, dept_name FROM TBL_AGENCY`
  let values = []

  if (req.user.type === 'org') {
    sql += ' WHERE org_name = ? && dept_name = ?'
    values.push(req.user.org_name)
    values.push(req.user.dept_name)
  }

  const results = await oneQuery(sql, values)

  const group = results.reduce((acc, item) => ({
    ...acc,
    [item.org_code]: acc[item.org_code] ? [...acc[item.org_code], item] : [item]
  }), {})

  const responseData = Object.entries(group).map(([org_code, item]) => ({
    org_code,
    org_name: item[0].org_name,
    depts: item.map(({ dept_code, dept_name }) => ({ dept_code, dept_name }))
  }))

  res.json(responseData)
})


// 발송기관 전부 가져오기
router.get('/org', async (req, res) => {

  let sql = `SELECT * FROM TBL_AGENCY`
  let values = []

  //kimcy
  if (req.user.type === 'org' && req.user.authority === 'admin') {
    sql += ' WHERE org_name = ?'
    values.push(req.user.org_name)
  }

  else if (req.user.type === 'org') {
    sql += ' WHERE org_name = ? && dept_name = ?'
    values.push(req.user.org_name)
    values.push(req.user.dept_name)
  }

  const results = await oneQuery(sql, values)

  res.json(results)
})


// 발송기관 하나만 가져오기
router.get('/org/:id', async (req, res) => {
  const { id } = req.params

  const results = await oneQuery(`SELECT * FROM TBL_AGENCY WHERE idx = ${id}`)

  res.json(results)
})

// 발송기관 하나만 가져오기
router.get('/org/search/:type/:org/:dept', async (req, res) => {
  const { type, org, dept } = req.params

  const result = type === 'name'
    ? await oneQuery(`SELECT * FROM TBL_AGENCY WHERE org_name = ? AND dept_name = ?`, [org, dept])
    : await oneQuery(`SELECT * FROM TBL_AGENCY WHERE org_code = ? AND dept_code = ?`, [org, dept])

  res.json(result[0])
})

// 발송기관 추가하기
router.post('/org', uploadMW.single('icon'), async (req, res) => {
  const data = req.body

  data.icon_link = await file.insert(req.file)
  await oneQuery(`INSERT INTO TBL_AGENCY SET ?`, data)

  res.send('ok')
})


// 발송기관 수정하기
router.put('/org/:id', uploadMW.single('icon'), async (req, res) => {
  const { id } = req.params
  const data = req.body

  const before = await oneQuery(`SELECT * FROM TBL_AGENCY WHERE idx = ?`, [id])
  
  if (req.file) {
    await file.delete(before.icon_link)
    data.icon_link = await file.insert(req.file)
  }

  delete data.icon
  
  await oneQuery(`UPDATE TBL_AGENCY SET ? WHERE idx = ?`, [ data, id ])
  await oneQuery(`UPDATE TBL_AGENCY_USER SET ? WHERE id = ?`, [
    {
      org_name: data.org_name,
      dept_name: data.dept_name
    },
    id
  ])

  res.send('ok')
})


// 발송기관 삭제하기
router.delete('/org/:id', async (req, res) => {
  const { id } = req.params

  const before = await oneQuery(`SELECT icon_link FROM TBL_AGENCY WHERE idx = ?`, [id])

  if (before.icon_link) {
    await file.delete(before.icon_link)  
  }

  await oneQuery(`DELETE FROM TBL_AGENCY WHERE idx = ?`, [id])

  res.send('ok')
})


// 서식 전부 가져오기
router.get('/format', async (req, res) => {
  const user = req.user

  let where = ''
  let values = []

  //kimcy
  if (user.type === 'org' && user.authority !== 'admin') {
    const [{ idx: agencyID }] = await oneQuery(`SELECT idx FROM TBL_AGENCY WHERE org_name = ? && dept_name = ?`, [user.org_name, user.dept_name])

    where = `WHERE t.agency_id = ?`
    values.push(agencyID)
  }


  const results = await oneQuery(`
    SELECT
      t.*,
      a.org_name as org_name
    FROM
      TBL_TEMPLATE as t
    LEFT JOIN
      TBL_AGENCY as a
    ON
      a.idx = t.agency_id
    ${where}
    ORDER BY t.idx DESC`,
    values
  )

  res.json(results)
})

// 서식 가져오기
router.get('/format/:id', async (req, res) => {
  const { id } = req.params
  const [ result ] = await oneQuery(`SELECT * FROM TBL_TEMPLATE WHERE idx = ?`, [ id ])

  res.json(result)
})

// 서식 등록하기
router.post('/format', async (req, res) => {
  const data = req.body

  await oneQuery(`INSERT INTO TBL_TEMPLATE SET ?`, [data])

  res.send('ok')
})

// 서식 수정하기
router.put('/format/:id', async (req, res) => {
  const { id } = req.params
  const data = req.body
  
  await oneQuery(`UPDATE TBL_TEMPLATE SET ? WHERE idx = ?`, [data, id])

  res.send('ok')
})

// 서식 삭제하기
router.delete('/format/:id', async (req, res) => {
  const { id } = req.params

  await oneQuery(`DELETE FROM TBL_TEMPLATE WHERE idx = ?`, [id])

  res.send('ok')
})


// 콜 전부 가져오기
router.get('/call', async (req, res) => {
  const results = await oneQuery(`SELECT * FROM TBL_CALL ORDER BY reg_dt DESC`)

  res.json(results)
})


// 콜 하나 가져오기
router.get('/call/:id', async (req, res) => {
  const { id } = req.params
  
  const results = await oneQuery(`SELECT * FROM TBL_CALL WHERE id = ?`, [id])

  res.json(results)
})


// 콜 추가하기
router.post('/call', async (req, res) => {
  const data = req.body

  await oneQuery(`INSERT INTO TBL_CALL SET ?`, data)

  res.send('ok')
})


// 콜 수정하기
router.put('/call/:id', async (req, res) => {
  const { id } = req.params
  const data = req.body

  await oneQuery(`UPDATE TBL_CALL SET ? WHERE id = ?`, [data, id])

  res.send('ok')
})


// 콜 삭제하기
router.delete('/call/:id', async (req, res) => {
  const { id } = req.params

  await oneQuery(`DELETE FROM TBL_CALL WHERE id = ?`, [id])

  res.send('ok')
})


// 공지사항 전부 가져오기
router.get('/notice', async (req, res) => {
  const results = await oneQuery(`SELECT * FROM TBL_NOTICE ORDER BY reg_dt DESC`)

  res.json(results)
})


// 공지사항 하나만 가져오기
router.get('/notice/:id', async (req, res) => {
  const { id } = req.params

  const results = await oneQuery(`SELECT * FROM TBL_NOTICE WHERE id = ?`, [id])

  res.json(results)
})


// 공지사항 추가하기
router.post('/notice', uploadMW.single('file'), async (req, res) => {
  const data = req.body

  if (req.file) {
    data.file = await file.insert(req.file)
  }

  await oneQuery(`INSERT INTO TBL_NOTICE SET ?`, data)

  res.send('ok')
})


// 공지사항 수정하기
router.put('/notice/:id', uploadMW.single('file'), async (req, res) => {
  const { id } = req.params
  const data = req.body

  const before = await oneQuery(`SELECT file FROM TBL_NOTICE WHERE id = ?`, [id])

  if (req.file) {
    before.file && await file.delete(before.file)

    data.file = await file.insert(req.file)
  }

  await oneQuery(`UPDATE TBL_NOTICE SET ? WHERE id = ?`, [data, id])

  res.send('ok')
})


// 공지사항 삭제하기
router.delete('/notice/:id', async (req, res) => {
  const { id } = req.params

  const before = await oneQuery(`SELECT file FROM TBL_NOTICE WHERE id = ?`, [id])

  before.file && await file.delete(before.file)

  await oneQuery(`DELETE FROM TBL_NOTICE WHERE id = ?`, [id])

  res.send('ok')
})


// 블록체인 채널 가져오기
router.get('/bc/channel', async (req, res) => {
  const result = await oneQuery(`SELECT channel_name FROM TBL_BCCHANNEL`)

  res.json(result.map(x => x.channel_name))
})


// 블록체인 기관 가져오기
router.get('/bc/org', async (req, res) => {
  const result = await oneQuery(`SELECT org_name FROM TBL_BCORG`)

  res.json(result.map(x => x.org_name))
})


router.get('/query/trace/:query', async (req, res) => {
  const { query } = req.params

  const result = await request.get('http://biz.epost.go.kr/KpostPortal/openapi', {
    qs: {
      regKey: '2b1712e401e3f7ffd1585626683991',
      target: 'trace',
      query
    }
  })

  parseString(result, (err, data) => {
    res.json(data)
  })
})

router.post('/my/modify/:userId/:type', async (req, res) => {
  const { userId, type } = req.params
  const data = req.body

  if (type === 'system') {
    await oneQuery(`UPDATE TBL_SYSTEM_USER SET manager = ?, contact = ?, email = ? WHERE id = ?`, [
      data.manager,
      data.contact,
      data.email,
      userId
    ])
  } else {
    await oneQuery(`UPDATE TBL_AGENCY_USER SET manager = ?, contact = ?, email = ? WHERE id = ?`, [
      data.manager,
      data.contact,
      data.email,
      userId      
    ])
  }

  res.send('ok')
})


// 증명서 발급 이력 전부 가져오기
router.get('/cert/history', async (req, res) => {
  const results = await oneQuery(`SELECT * FROM TBL_PROOF_OF_DISTRIBUTION_LOG ORDER BY issue_datetime DESC`)

  res.json(results)
})



module.exports = router
