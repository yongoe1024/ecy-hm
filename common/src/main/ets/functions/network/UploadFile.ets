import { fileIo } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';
import { AxiosProgressEvent, FormData } from '@ohos/axios';
import { request } from './Request';
import { DownloadParams, UploadParams } from '..';

export class UploadFile {
  /**
   * 上传文件
   */
  static async upload<T = ESObject>(params: UploadParams): Promise<T> {
    if (!params.url || !params.filePath) {
      Promise.reject()
    }
    const cachePath = await copyToCache(params.filePath)
    if (params.formData == undefined) {
      params.formData = new FormData()
    }
    params.formData.append('file', cachePath);
    // 发送请求
    return request.request<T>({
      url: params.url,
      method: 'post',
      data: params.formData,
      headers: { 'Content-Type': 'multipart/form-data' },
      params: params.params,
      context: getContext(),
      onUploadProgress: (progressEvent: AxiosProgressEvent): void => {
        if (progressEvent && progressEvent.loaded && progressEvent.total) {
          params.onProgress && params.onProgress(progressEvent.loaded / progressEvent.total * 100)
        }
      },
    })
  }


  /**
   * 下载，！仅能下载到cacheDir目录！,已存在会下载失败
   */
  static download<T = ESObject>(params: DownloadParams): Promise<T> {
    return request.request<T>({
      url: params.url,
      method: 'get',
      context: getContext(),
      filePath: params.filePath,
      onDownloadProgress: (progressEvent: AxiosProgressEvent): void => {
        if (progressEvent && progressEvent.loaded && progressEvent.total) {
          params.onProgress && params.onProgress(progressEvent.loaded / progressEvent.total * 100)
        }
      }
    })
  }
}


/**
 * 将文件复制到缓存，重命名，得到 internal://cache
 */
export async function copyToCache(path: string) {
  let dir = getContext().cacheDir
  let type = path.split('.').pop()
  let uuid = util.generateRandomUUID() + '.' + type
  let pathIO = fileIo.openSync(path, fileIo.OpenMode.READ_ONLY)
  fileIo.copyFileSync(pathIO.fd, `${dir}/${uuid}`)
  fileIo.closeSync(pathIO);
  return `internal://cache/${uuid}`
}