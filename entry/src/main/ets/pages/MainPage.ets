import { AppStorageName, GlobalStyle, RouteManager, UploadFile } from "common"
import { MinePage } from "mine"

@Builder
export function MainPageBuilder() {
  MainPage()
}

/**
 * 主页
 */
@Component
export struct MainPage {
  @State selectIndex: number = 0

  aboutToAppear(): void {

  }

  @Builder
  tabBar(title: string, icon: Resource, active: Resource, index: number) {
    Column({ space: 8 }) {
      Image(this.selectIndex === index ? active : icon)
        .width(18)
      Text(title)
        .fontSize(14)
        .fontColor(index === this.selectIndex ? '#e89297' : '#999')
    }
    .onClick(() => {
      this.selectIndex = index
    })
  }

  build() {
    NavDestination() {
      Tabs({ index: $$this.selectIndex }) {

        TabContent() {
          Column() {
            Text('页面')
          }
        }

        TabContent() {
          Text('页面')
        }

        TabContent() {
          MinePage()
        }
      }
      .layoutWeight(1)
      .barHeight(0)

      Row({ space: 30 }) {
        this.tabBar('首页', $r("app.media.entry_ic_main_home"), $r("app.media.entry_ic_main_home_active"), 0)
        this.tabBar('购物车', $r("app.media.entry_ic_main_shop"), $r("app.media.entry_ic_main_shop_active"), 1)
        this.tabBar('我的', $r("app.media.entry_ic_main_mine"), $r("app.media.entry_ic_main_mine_active"), 2)
      }
      .padding({ top: 10 })
      .borderColor('#eee')
      .borderWidth({ top: 1 })
      .justifyContent(FlexAlign.SpaceAround)
      .width('100%')
    }
    .attributeModifier(GlobalStyle.navModifier)
    .onShown(() => {
      // 跳转到 want页面
      const wantUri = AppStorage.get<string>(AppStorageName.APP_WANT_URI)
      if (wantUri) {
        RouteManager.getInstance().push(wantUri)
      }
    })
  }
}

