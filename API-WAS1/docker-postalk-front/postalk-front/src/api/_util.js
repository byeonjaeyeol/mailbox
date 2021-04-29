import axios from 'axios'
//const path = require('path');
//todo
import {API_ADDRESS} from '../config.js'
//const
//const config  = require('../config.js');

// imagine we had a method to get language from cookies or other storage
// const language = detectVisitorLanguage();
// import(`./locale/${language}.json`).then((module) => {
//   // do something with the translations
// });

// const configPath = path.join(__dirname,'..','config.js')
// console.log("path = ", configPath.);
//var API_ADDRESS = configPath
//todo
const instanceAxios = axios.create({
  baseURL: API_ADDRESS,
  withCredentials: false,
})

instanceAxios.defaults.headers.common['Authorization'] = `Bearer ${window.localStorage.getItem('token')}`

export default instanceAxios
