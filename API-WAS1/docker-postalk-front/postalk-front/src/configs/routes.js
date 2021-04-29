const prefix = ''
const index_page = 'Index'

const routes = [
  {
    label: '대시보드',
    path: '/',
    children: [],
  },
  {
    label: '우편물 발송 조회',
    path: '/posting/lookup',
    children: [],
  },
  {
    label: '수발신 증명서 발급 이력',
    path: '/cert/history',
    children: [],
    system: true,
    admin: true
  },
  {
    label: '통계',
    children: [
      { label: '우편물 발송 통계', path: '/posting/statistics' },
      { label: '회원 통계', path: '/member/statistics', system: true }
    ]
  },
  {
    label: '계정 관리',
    children: [
      { label: '시스템 계정', path: '/system/account', isActive: '/system/account(/.*)?', system: true },
      { label: '수정', parent: '/system/account', path: '/system/account/modify/:memberId', hidden: true, system: true },
      { label: '발송기관 계정', path: '/org/account', isActive: '/org/account(/.*)?', system: true , admin: true},
      { label: '수정', parent: '/org/account', path: '/org/account/modify/:memberId', hidden: true, system: true, admin: true },
      { label: '회원 계정', path: '/member/account', system: true },
      { label: '상세보기', parent: '/member/account', path: '/member/account/view/:memberId', hidden: true, system: true }
    ],
    system: true,
    admin: true
  },
  {
    label: '발송기관 관리',
    children: [
      { label: '발송기관 등록', path: '/org/add', system: true },
      { label: '발송기관 목록', path: '/org', isActive: '/org{/modify/:orgId}?', system: true },
      { label: '수정', parent: '/org', path: '/org/modify/:orgId', hidden: true, system: true }
    ],
    system: true
  },
  {
    label: '서식 관리',
    children: [
      { label: '서식 등록', path: '/format/add', /* system: true */ },
      { label: '서식 목록', path: '/format', isActive: '/format{/modify/:id}?', /* system: true */ },
      { label: '수정', parent: '/format', path: '/format/modify/:id', hidden: true, /* system: true */ }
    ],
    /* system: true */
  },
  {
    label: '민원 관리',
    //system: true,
    children: [
      { label: '민원 관리', path: '/call', isActive: '/call(/.*)?', system: true },
      { label: '민원 등록', path: '/call/add', hidden: true, system: true },
      { label: '민원 보기', path: '/call/modify/:id', hidden: true, system: true },
    ],
    system: true
  },
  {
    //todo 배너 관리
    label: '운영관리',
    //system: true,
    children: [
      { label: '공지사항 관리', path: '/notice', isActive: '/notice(/.*)?', system: true },
      { label: '공지사항 등록', path: '/notice/add', hidden: true, system: true },
      { label: '공지사항 보기', path: '/notice/modify/:id', hidden: true, system: true },
      { label: '배너 관리', path: '/banner', isActive: '/banner(/.*)?', system: true },
    ],
    system: true
  },
  {
    label: '접속 이력',
    children: [
      { label: '시스템 계정', path: '/connection/system', system: true },
      { label: '발송기관 계정', path: '/connection/org', system: true, admin: true },
      // { label: '전자우편사서함 계정', path: '/404' }
    ],
    system: true,
    admin: true
  },
  {
    label: '내 정보 관리',
    children: [
      { label: '비밀번호 변경', path: '/password' },
      { label: '내 정보 관리', path: '/my/modify' }
    ]
  },
  {
    label: '로그인',
    path: '/login',
    hidden: true,
    children: [],
  }
]

const getPageComponent = (path) => {
  return require(`../pages/${
    path
      .replace(/\/:.*/, '')
      .split('/')
      .map(path => `${path.charAt().toUpperCase()}${path.slice(1)}`)
      .join('') || index_page
    }`).default
}

const getPreFixPathItem = (item) => {
  let after = JSON.parse(JSON.stringify(item))

  if (item.path) {
    after.path = prefix + item.path

    if (item.isActive)
      after.isActive = prefix + item.isActive
  }

  return after
}

export const realRoutes = routes.reduce((acc, route) => ([
  ...acc,
  ...(route.path ? [{ ...getPreFixPathItem(route), component: getPageComponent(route.path) }] : []),
  ...(route.children ? route.children.map(sub => ({ ...getPreFixPathItem(sub), component: getPageComponent(sub.path) })) : [])
]), [])

// 재귀로 리팩토링
export const findRoutes = (targetPath) => {
  let result = []

  routes.forEach(val => {
    if (targetPath === val.path) {
      result = [val]
      return false
    }

    if (val.children) {
      const findVal = val.children.find(x => targetPath === x.path)

      if (findVal) {
        if (findVal.parent) {
          const parentFindVal = val.children.find(x => findVal.parent === x.path)

          result = [val, parentFindVal, findVal]
          return false
        }
        result = [val, findVal]
        return false
      }
    }

    return true
  });

  if (result.length === 0) {
    return []
  }

  return result
}

export default routes.map(item => ({
  ...getPreFixPathItem(item),
  ...(item.children ? { children: item.children.map(sub => getPreFixPathItem(sub)) } : {})
}))
