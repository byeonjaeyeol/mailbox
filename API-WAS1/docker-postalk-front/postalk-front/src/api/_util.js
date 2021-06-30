import axios from 'axios'

import {API_ADDRESS} from '../config.js'

const instanceAxios = axios.create({
  baseURL: API_ADDRESS,
  withCredentials: false,
})

instanceAxios.defaults.headers.common['Authorization'] = `Bearer ${window.localStorage.getItem('token')}`

export default instanceAxios
