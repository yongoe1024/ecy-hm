import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { KeyboardAvoidMode, window } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import { IBestInit } from '@ibestservices/ibest-ui';
import { AppStorageName } from 'common';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    if (want.parameters !== undefined) {
      let params: Record<string, string> = JSON.parse(JSON.stringify(want.parameters));
      // 将想要跳转的路由传到AppStorage，在根页面跳转
      AppStorage.setOrCreate(AppStorageName.APP_WANT_URI, params[AppStorageName.APP_WANT_URI])
    }
    // 初始化webview
    webview.WebviewController.initializeWebEngine();
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    if (want.parameters !== undefined) {
      let params: Record<string, string> = JSON.parse(JSON.stringify(want.parameters));
      // 将想要跳转的路由传到AppStorage，在根页面跳转
      AppStorage.setOrCreate(AppStorageName.APP_WANT_URI, params[AppStorageName.APP_WANT_URI])
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    AppStorage.setOrCreate(AppStorageName.WINDOW_STAGE, windowStage)
    windowStage.loadContent('pages/Index', (err) => {
      // 初始化UI组件库
      IBestInit(windowStage, this.context)
      const windowClass = windowStage.getMainWindowSync()
      // 设置键盘压缩模式
       //windowClass.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
      this.updateWinInfo(windowClass)
    });
  }

  /**
   * 存储窗口高度
   */
  updateWinInfo(windowClass: window.Window) {
    // 1. 设置窗口全屏
    windowClass.setWindowLayoutFullScreen(true)
    // 2. 注册监听函数，动态获取避让区域数据
    const statusBar = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
    const navigationArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    const bottomRectHeight = navigationArea.bottomRect.height; // 获取到导航条区域的高度
    // 获取状态栏高度
    AppStorage.setOrCreate('topRectHeight', px2vp(statusBar.topRect.height))
    // 获取导航条高度
    AppStorage.setOrCreate('bottomRectHeight', px2vp(bottomRectHeight))
    // 获取窗口宽高
    const props = windowClass.getWindowProperties()
    AppStorage.setOrCreate('windowWidth', px2vp(props.windowRect.width))
    AppStorage.setOrCreate('windowHeight', px2vp(props.windowRect.height))
    // 3. 注册监听函数，监听安全区大小变化
    try {
      // 监听窗口变化
      windowClass.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          const topRectHeight = data.area.topRect.height;
          AppStorage.setOrCreate('topRectHeight', px2vp(topRectHeight));
        } else if (data.type == window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          const bottomRectHeight = data.area.bottomRect.height;
          AppStorage.setOrCreate('bottomRectHeight', px2vp(bottomRectHeight));
        }
      })
    } catch (exception) {
      console.error(`Failed to enable the listener for system avoid area changes. Cause code: ${exception.code}, message: ${exception.message}`);
    }
    // 4. 注册监听函数，监听窗口大小变化
    try {
      windowClass.on('windowSizeChange', (data) => {
        AppStorage.setOrCreate('windowWidth', px2vp(data.width))
        AppStorage.setOrCreate('windowHeight', px2vp(data.height))
      });
    } catch (exception) {
      console.error(`Failed to enable the listener for window size changes. Cause code: ${exception.code}, message: ${exception.message}`);
    }
    //   5 监听键盘高度
    windowClass.on('keyboardHeightChange', (data: number) => {
      AppStorage.setOrCreate('keyboardHeight', px2vp(data))
    })
  }
}