/**
 * 路由参数
 */
export class RouterParams {
  // web url
  webUrl?: string
  //需要登录
  needLogin: boolean = false
  // 转场动画
  animated: boolean = true
  // 在页面出栈时获取返回信息
  onPop?: ((popInfo: PopInfo) => void) | undefined = undefined
  // 参数
  private paramsMap: Map<string, object> | undefined = undefined

  public put(key: string, value: object) {
    if (!this.paramsMap) {
      this.paramsMap = new Map<string, object>()
    }
    if (this.paramsMap) {
      this.paramsMap.set(key, value)
    }
  }

  public get(key: string): object | undefined {
    if (this.paramsMap) {
      return this.paramsMap.get(key)
    }
    return undefined
  }
}
