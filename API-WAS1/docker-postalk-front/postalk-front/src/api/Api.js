
import axios from './_util'
import _axios from 'axios'
import querystring from 'querystring'
//todo
//import {POSTOK_API_HOST} from '../config'
const config  = require('../config.js');


const Api = {
  async changePassword(id, data) {
    const response = await axios.put(`password/${id}`, data)

    return response
  },

  async queryTrace(query) {
    const response = await axios.get(`query/trace/${query}`)

    return response.data
  },

  async searchOrg(type, org, dept) {
    const response = await axios.get(`org/search/${type}/${org}/${dept}`)

    return response.data
  },

  async getFormat(id) {
    const response = await axios.get(`format/${id}`)

    return response.data
  },

  async addFormat(form) {
    const response = await axios.post(`format`, form)

    return response
  },

  async modifyFormat(id, data) {
    const response = await axios.put(`format/${id}`, data)

    return response
  },

  async deleteFormat(id) {
    const response = await axios.delete(`format/${id}`)

    return response
  },

  async existDeptCode(code) {
    const response = await axios.get(`/org/dept/exist/${code}`)
    return response.data
  },

  //todo
  async existOrg(code) {
    const response = await _axios.get(`${config.POSTOK_API_HOST}/regs/agency/${code}`)
    return response.data
  },

  async getBCChannel() {
    const response = await axios.get(`/bc/channel`)

    return response.data
  },

  async getBCOrg() {
    const response = await axios.get(`/bc/org`)

    return response.data
  },

  async getDateByData (data) {

    const response  = await axios.post('/stats/time', data, {
      'Content-Type': 'application/json'
    });

    return response.data;
  },

  async getFile(id) {
    const response = await axios.get(`/upload/${id}`)

    return response.data
  },

  async getOrgDepts() {
    const response = await axios.get(`org/dept`)

    return response.data
  },

  async getSendData(data) {
    const response = await axios.get(`/mail/send?${querystring.stringify(data)}`);
    return response.data;
  },

  async getReceiveData(data) {
    const response = await axios.get(`/mail/receive?${querystring.stringify(data)}`);
    return response.data;
  },

  async getSignUpData(data) {
    const response = await axios.get(`/member/stats?${querystring.stringify(data)}`);
    return response.data;
  },

  async getMemberStatistics(data) {
    const response = await axios.get(`/member/stats/day?${querystring.stringify(data)}`);
    return response.data;
  },

  async getPostSend({ page_from, page_size, org_code, dept_code, start, end, name, reg_num, req_id }) {
    const body = {
      page_from,
      page_size,
      org_code,
      dept_code,
      gte: start,
      lt: end
    }

    if (name) body.name = name
    if (reg_num) body.reg_num = reg_num
    if (req_id) body.req_id = req_id

    const url = name ? 'name' : reg_num ? 'dmregnum' : req_id ? 'reqid' : 'time'
    //todo
    const response = await _axios.post(`${config.POSTOK_API_HOST}/stats/${url}`, body)

    return response.data
  },

  async getPostStatistics() {
    const response = await axios.get(`/post/statistics`)
    return response.data
  },

  async getAccounts(type, pagingInfo = {}) {
    let keyword = pagingInfo.keywords
    const response = await axios.get(`/account/${type}${pagingInfo ? `?page=${pagingInfo.page}&pageSize=${pagingInfo.pageSize}${keyword ? `&keywords=`+JSON.stringify(keyword) : ''}` : ''}`)
    return response.data
  },

  async getAccount(type, id) {
    const response = await axios.get(`/account/${type}/${id}`)

    return response.data
  },

  async addAccount(type, data) {
    const response = await axios.post(`account/${type}`, data)

    return response
  },

  async modifyAccount(type, data) {
    const response = await axios.put(`account/${type}/${data.id}`, data)

    return response
  },

  async deleteAccount(type, id) {
    const response = await axios.delete(`account/${type}/${id}`)

    return response
  },

  async getOrgs() {
    const response = await axios.get(`org`)

    return response.data
  },

  async getOrg(id) {
    const response = await axios.get(`org/${id}`)

    return response.data
  },

  async addOrg(form) {
    const response = await axios.post(`org`, form)

    return response
  },

  async modifyOrg(form, id) {
    const response = await axios.put(`org/${id}`, form)

    return response
  },

  async deleteOrg(id) {
    const response = await axios.delete(`org/${id}`)

    return response
  },

  async addCall(data) {
    const response = await axios.post(`call`, data)

    return response
  },

  async getCalls() {
    const response = await axios.get(`call`)

    return response.data
  },

  async getCall(id) {
    const response = await axios.get(`call/${id}`)

    return response.data
  },

  async modifyCall(id, data) {
    const response = await axios.put(`call/${id}`, data)

    return response
  },

  async deleteCall(id) {
    const response = await axios.delete(`call/${id}`)

    return response
  },

  async addNotice(form) {
    const response = await axios.post(`notice`, form)

    return response
  },

  async getNotices() {
    const response = await axios.get(`notice`)

    return response.data
  },

  async getNotice(id) {
    const response = await axios.get(`notice/${id}`)

    return response.data
  },

  async modifyNotice(id, data) {
    const response = await axios.put(`notice/${id}`, data)

    return response
  },

  async deleteNotice(id) {
    const response = await axios.delete(`notice/${id}`)

    return response
  },

  async signIn(data) {
    const response = await axios.post(`signIn`, data)

    return response
  },

  async existUser(id) {
    const response = await axios.get(`account/exist/${id}`)

    return response
  },

  async getConnection(type) {
    const response = await axios.get(`connection/${type}`)

    return response
  },

  async getFormats(agency) {
    const response = await axios.get(`format?agency=${agency}`);
    return response.data
  },

  async myModify(userId, type, data) {
    const response = await axios.post(`/my/modify/${userId}/${type}`, data);
    return response.data
  },

  async getCertHistory() {
    const response = await axios.get(`/cert/history`)
    return response.data
  },

  async addCertHistory(data) {
    const response = await axios.post(`/cert/history`, { data: JSON.stringify(data) })
    return response.data
  }
}

export default Api;
