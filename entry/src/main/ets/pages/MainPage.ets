import { AppStorageName, GlobalStyle,
  LocationManager,
  RouteManager, RouterParams, RouteTable, UploadFile } from "common"
import { MinePage } from "mine"
import { router } from "@kit.ArkUI"
import { locationManager } from "@kit.MDMKit"
import { geoLocationManager } from "@kit.LocationKit"

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
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 0;

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
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/DemoXX'
                })
              })
          }
        }

        TabContent() {
          Text('页面')
            .onClick(() => {
              // let param = new RouterParams()
              // param.put('imgList',['https://ts2.cn.mm.bing.net/th?id=ORMS.ec6616ee3692fbeea907d12b865dfd03&pid=Wdp&w=612&h=304&qlt=90&c=1&rs=1&dpr=2&p=0',
              // 'https://developer.huawei.com/consumer/cn/blog/assets/images/home/default_header.gif'])
              // param.put('showIndex',1)
              // RouteManager.getInstance().push(RouteTable.IMG_PREVIEW,param)
              // let param = new RouterParams()
              // param.put('filePath',
              //   'https://ts2.cn.mm.bing.net/th?id=ORMS.ec6616ee3692fbeea907d12b865dfd03&pid=Wdp&w=612&h=304&qlt=90&c=1&rs=1&dpr=2&p=0')
              // param.put('radius', '0%')
              // param.put('ratio', 1)
              // param.put('containerSize', '100%')
              // param.onPop= (popInfo: PopInfo)=>{
              //   let model: PixelMap = popInfo.result as PixelMap
              // }
              // RouteManager.getInstance().push(RouteTable.IMG_CROP, param)
              LocationManager.getInstance().updateInfo()
            })
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
      .padding({ top: 10, bottom: this.bottomRectHeight })
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

