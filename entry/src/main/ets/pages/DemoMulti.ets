import { AppStorageName } from "common";

/**
 *
 *
 * @author yongoe
 * @since 2025−03-01
 * @version v1.0
 */
@Entry
@Component
export struct DemoMulti {
  @StorageProp('currentWidthBreakpoint') breakpoint: string = ''
  @State pathInfo: NavPathStack = new NavPathStack();
  @State sideBarStatus: boolean = false;
  @State sideBarWidth: number = 304;
  @StorageProp(AppStorageName.topRectHeight) topRectHeight: number = 0

  // 子页面分栏显示
  @Builder
  myRouter(name: string, param?: number | undefined) {
    if (name == 'one') {
      WlanItem()
    }
  }

  // 默认触发分栏
  aboutToAppear() {
    if (this.breakpoint !== 'sm') {
      this.pathInfo.pushPath({ name: 'one' });
    }
  }

  build() {
    Column() {
      //子组件个数：必须且仅包含2个子组件。
      SideBarContainer(SideBarContainerType.AUTO) {
        Column() {
          Text('ss')
        }.backgroundColor('#f1f3f5').width('100%').height('100%')

        Column() {
          Stack() {
            Navigation(this.pathInfo) {
              List({ space: 10 }) {
                ListItem() {
                  Text('sssss')
                }

                ListItem() {
                  Text('sssss')
                }

                ListItem() {
                  Text('sssss')
                }

                ListItem() {
                  Text('sssss')
                }
              }
              .width('100%').height('100%')
              .padding({ left: 12, right: 12 })
            }
            // 分栏首页宽度
            .navBarWidth(400) //设置导航栏宽度。仅在Navigation组件分栏时生效。
            .title('设置')
            .backgroundColor('#f1f3f5')
            .width('100%')
            .height('100%')
            .navDestination(this.myRouter)
            // 背景板
            if (this.sideBarStatus && this.breakpoint !== 'lg') {
              Column().width('100%').height('100%').backgroundColor('#33000000')
            }
          }

        }
      }
      .controlButton({
        left: 24,
        top: 16,
        width: 24,
        height: 24
      })
      // 菜单栏宽度
      .sideBarWidth(this.sideBarWidth)
      // 最小宽度
      .minSideBarWidth(240)
      // 内容最小宽度，适合三栏时候用
      .minContentWidth(this.breakpoint === 'sm' ? 360 : 600)
      // 开屏不是大屏不显示，因为大屏直接三栏
      .showSideBar(this.breakpoint === 'lg')
      .onChange((value: boolean) => {
        this.sideBarStatus = value;
      })

    }
    .padding({ top: this.topRectHeight })
    .width('100%')
    .height('100%')

  }
}


@Component
export struct WlanItem {
  build() {
    NavDestination() {
      Row() {
        Text('ss')
      }

    }.title('WLAN')
    .hideTitleBar(true)
    .backgroundColor('#f1f3f5')
  }
}

