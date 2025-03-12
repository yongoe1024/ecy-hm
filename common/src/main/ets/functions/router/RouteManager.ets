import { AppStorageName, } from "../../constants";
import { RouterParams } from "./RouterParams";
import { RouteTable } from "./RouteTable";
import Url from '@ohos.url'

/**
 * 路由管理类
 */
export class RouteManager {
  private static instance?: RouteManager

  private constructor() {
  }


  public static getInstance(): RouteManager {
    if (!RouteManager.instance) {
      RouteManager.instance = new RouteManager()
    }
    return RouteManager.instance;
  }

  /**
   * 获取当前的页面视图栈（NavPathStack）
   */
  public get currentNavStack(): NavPathStack | undefined {
    return AppStorage.get<NavPathStack>(AppStorageName.NavPathStack)
  }

  /**
   * 返回页面
   */
  public pop(animated?: boolean) {
    this.currentNavStack?.pop(animated)
  }

  /**
   * 返回到指定页面
   */
  public popTo(pathName: string, animated?: boolean) {
    this.currentNavStack?.popToName(pathName, animated)
  }

  /**
   * 返回到根页面
   */
  public popToRoot(animated?: boolean) {
    this.currentNavStack?.popToName(RouteTable.ENTRY_INDEX)
  }

  /**
   * 返回页面：带参数
   */
  public popResult(result: Object, animated?: boolean) {
    this.currentNavStack?.pop(result, animated)
  }

  /**
   * 跳转
   */
  public push(pagePath: string, options?: RouterParams) {
    if (!pagePath) {
      return
    }
    if (!options) {
      options = new RouterParams()
    }
    // 需要登录
    if (options?.needLogin && !AppStorage.get(AppStorageName.USER)) {
      this.currentNavStack?.pushPathByName(RouteTable.ENTRY_LOGIN, null, true)
      return
    }
    // web页面
    if (pagePath.startsWith("https") || pagePath.startsWith("http")) {
      // 打开Web
      options.webUrl = pagePath
      this.currentNavStack?.pushPathByName(RouteTable.COMMON_WEB, pagePath, (popInfo: PopInfo) => {
        options?.onPop && options?.onPop(popInfo)
      }, options?.animated)
    } else {
      // 将问号后的参数变成Map
      const myURL = Url.URL.parseURL(pagePath)
      const objectParams = new Url.URLParams(myURL.search)
      objectParams.forEach((value, key) => {
        options?.put(key, value as ESObject)
      });

      // 开始跳转，传入 真实路由参数
      this.currentNavStack?.pushPathByName(
        pagePath.split('?')[0],
        options,
        (popInfo: PopInfo) => {
          options?.onPop && options?.onPop(popInfo)
        },
        options?.animated
      )
    }
  }
}