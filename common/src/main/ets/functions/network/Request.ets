/**
 * axios请求封装
 * @author yongoe
 * @since 2024/8/23
 */
import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, FormData, InternalAxiosRequestConfig } from '@ohos/axios'
import { AppStorageName, CommonConstants } from '../../constants'
import { ResponseModel } from './RequestModel'
import { Logger } from '../../utils/Logger'
import { IBestToast } from '@ibestservices/ibest-ui'
import { RouteManager } from '../router/RouteManager'
import { RouteTable } from '../router/RouteTable'

const instance = axios.create({
  baseURL: CommonConstants.BASE_URL
})

instance.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const token = AppStorage.get<string>(AppStorageName.TOKEN)
    if (token) {
      config.headers[CommonConstants.TOKEN_HEADER] = token
    }
    return config
  }
)

instance.interceptors.response.use(
  (response: AxiosResponse) => {
    const res: ResponseModel = response.data
    Logger.debug(JSON.stringify(res))
    // 提示所有消息
    if (res.message) {
      IBestToast.show(res.message)
    }
    // 未登录
    if (res.code === 401) {
      AppStorage.delete(AppStorageName.USER)
      AppStorage.delete(AppStorageName.TOKEN)
      RouteManager.getInstance().push(RouteTable.ENTRY_LOGIN)
      return Promise.reject(res)
    } else if (res.code === 200) {
      return Promise.resolve(res.data)
    } else {
      return Promise.reject(res)
    }
  },
  (error: AxiosError) => {
    Logger.error(JSON.stringify(error))
    if (error.response && error.response.data) {
      const res: ResponseModel = error.response.data as ResponseModel
      if (res.message) {
        IBestToast.show(res.message)
      } else {
        IBestToast.show(error.message)
      }
      return Promise.reject(res)
    } else {
      IBestToast.show(error.message)
    }
    return Promise.reject(error)
  }
)

class Request {

  /**
   * 自定义请求
   */
  request<T = ESObject>(config: AxiosRequestConfig) {
    return instance.request<T, T>(config)
  }
  /**
   * @param url 路径
   * @param params 路径传参对象
   */
  get<T = ESObject>(url: string, params?: ESObject) {
    return instance.get<T, T>(url, { params })
  }

  /**
   * @param url 路径
   * @param data post参数对象
   * @param params 路径传参对象
   */
  post<T = ESObject>(url: string, data?: ESObject, params?: Record<string, ESObject>) {
    return instance.post<T, T>(url, data, { params })
  }

  /**
   * @param url 路径
   * @param data post参数对象
   * @param params 路径传参对象
   */
  put<T = ESObject>(url: string, data?: ESObject, params?: Record<string, ESObject>) {
    return instance.put<T, T>(url, data, { params })
  }

  /**
   * @param url 路径
   * @param params 路径传参对象
   */
  delete<T = ESObject>(url: string, params?: Record<string, ESObject>) {
    return instance.delete<T, T>(url, { params })
  }
}

export const request = new Request()
