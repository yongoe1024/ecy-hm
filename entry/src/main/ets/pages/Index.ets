import { AppStorageName, RouteManager, RouterParams, RouteTable } from 'common'

@Entry
@Component
struct Index {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack()
  @StorageProp(AppStorageName.topRectHeight)
  topRectHeight: number = 0
  @StorageProp(AppStorageName.bottomRectHeight)
  bottomRectHeight: number = 0

  aboutToAppear(): void {
    if (this.pageStack === undefined) {
      this.pageStack = new NavPathStack();
    }
    AppStorage.setOrCreate<NavPathStack>(AppStorageName.NavPathStack, this.pageStack)
    // 前往启动页初始化
    const param = new RouterParams()
    param.animated = false
    RouteManager.getInstance().push(RouteTable.ENTRY_LOADING, param)
  }

  async onPageShow(): Promise<void> {
    const wantUri = AppStorage.get<string>(AppStorageName.APP_WANT_URI)
    if (wantUri) {
      // 唤起APP之后的跳转地址
      if (RouteManager.getInstance().currentNavStack?.size() !== 0) {
        // 热启动，先返回到首页,在首页处理
        // 冷启动固定到首页，不操作
        RouteManager.getInstance().popToRoot(false)
      }
    }
  }

  build() {
    Navigation(this.pageStack) {
    }
    .hideTitleBar(true)
    .hideToolBar(true)
    .hideNavBar(true)
    .mode(NavigationMode.Stack)
  }
}

