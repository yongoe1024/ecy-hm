import { webview } from "@kit.ArkWeb"
/**
 * 事件消息
 */
export interface WebEventParam {
  type: string
  data: object
}
/**
 * 初始化消息
 */
export interface WebEventInitParam {
  onMessage?: (msg: WebEventParam) => void
  onArrayBufferMessage?: (msg: ArrayBuffer) => void
}
/**
 * web事件sdk
 */
export class WebEventSDK {
  private ports: webview.WebMessagePort[] = []
  private param: WebEventInitParam
  controller: WebviewController

  constructor(param: WebEventInitParam) {
    this.param = param
    this.controller = new webview.WebviewController()
  }

  init() {
    this.ports = this.controller.createWebMessagePorts()
    this.ports[0].onMessageEvent((result: webview.WebMessage) => {
      if (typeof (result) === 'string' && this.param.onMessage) {
        this.param.onMessage(JSON.parse(result) as WebEventParam)
      } else if (typeof (result) === 'object') {
        if (result instanceof ArrayBuffer && this.param.onArrayBufferMessage) {
          this.param.onArrayBufferMessage(result)
        } else {
          console.warn('h5向鸿蒙发的消息，不支持的回调类型 ' + typeof (result))
        }
      } else {
        console.warn('h5向鸿蒙发的消息，不支持的回调类型' + typeof (result));
      }
    })
    this.controller.postMessage("__init_port__", [this.ports[1]], "*")
  }

  /**
   * 发送消息到网页
   */
  postMessage(msg: ArrayBuffer | WebEventParam) {
    if (msg instanceof ArrayBuffer) {
      this.ports[0].postMessageEvent(msg)
    } else {
      this.ports[0].postMessageEvent(JSON.stringify(msg))
    }
  }
}

