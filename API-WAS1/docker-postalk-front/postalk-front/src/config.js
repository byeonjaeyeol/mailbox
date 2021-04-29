
/**
 * test-net
 * API_ADDRESS : http://15.165.68.163:8880/api
 * POSTOK_API_HOST : http://15.165.68.163:2100
 * @type {string|string}
 */
export const API_ADDRESS
    = process.env.NODE_ENV === 'development' ? 'http://localhost:8880/api' : window.location.origin + '/api'

//todo for using dev and production
export const POSTOK_API_HOST
    = process.env.NODE_ENV === 'development' ? 'http://localhost:2100' : 'https://if.postok.co.kr'
//
// //todo for test-net
// export const POSTOK_API_HOST
//     = process.env.NODE_ENV === 'development' ? 'http://15.165.68.163:2100' : 'http://15.165.68.163:2100'

export const CERT_API_URL = POSTOK_API_HOST+'/mailbox/distribution'

