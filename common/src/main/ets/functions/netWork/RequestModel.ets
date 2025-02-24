import { FormData } from "@ohos/axios"

/**
 * 统一返回类
 */
export interface ResponseModel {
  message: string
  code: number
  data: ESObject
}


/**
 * 上传文件参数
 */
export interface UploadParams {
  //接口路径
  url: string
  //文件路径,无限制
  filePath: string
  //表单数据
  formData?: FormData
  //路径传参
  params?: Record<string, object>
  //进度回调
  onProgress?: (value: number) => void
}

/**
 * 下载文件参数
 */
export interface DownloadParams {
  //请求url
  url: string
  //filePath 全路径 ---仅能下载到cacheDir目录
  filePath: string
  //进度回调
  onProgress?: (value: number) => void
}
