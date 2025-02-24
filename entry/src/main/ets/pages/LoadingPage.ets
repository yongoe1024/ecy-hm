import { Constants, GlobalStyle, PreferenceManager, RouteManager, RouterParams, RouteTable } from "common";
import { SplashPrivacyDialog } from "../components/SplashPrivacyDialog";
import { common } from "@kit.AbilityKit";
import { Advert } from "../components/Advert";

@Builder
export function LoadingPageBuilder() {
  LoadingPage()
}

/**
 * 加载页
 */
@Component
export struct LoadingPage {
  @Consume('pageStack') pageStack: NavPathStack;
  /**
   * 隐私协议
   */
  splashPrivacyController: CustomDialogController = new CustomDialogController({
    builder: SplashPrivacyDialog({
      cancel: () => {
        this.splashPrivacyController.close()
        const context = getContext(this) as common.UIAbilityContext
        context.terminateSelf()
      },
      confirm: () => {
        this.splashPrivacyController.close()
        PreferenceManager.getInstance().putSync(Constants.IS_AGREE_PRIVACY, true)
        this.initApp()
      },
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true,
  })

  initApp() {
    // 获取用户信息等操作
    setTimeout(() => {
      RouteManager.getInstance().currentNavStack?.clear(false)
      let params = new RouterParams()
      params.animated = false
      RouteManager.getInstance().push(RouteTable.ENTRY_INDEX, params)
    }, 1000)
  }

  build() {
    NavDestination() {
      Column() {
        Advert()
      }
      .width('100%')
      .height('100%')
    }
    .attributeModifier(GlobalStyle.navModifier)
    .onReady((context: NavDestinationContext) => {
      // 显示协议弹窗
      const result = PreferenceManager.getInstance().getSync<boolean>(Constants.IS_AGREE_PRIVACY)
      if (result) {
        this.initApp()
      } else {
        this.splashPrivacyController.open()
      }
    })
  }
}

