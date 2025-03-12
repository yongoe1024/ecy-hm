import { BusinessError } from "@kit.BasicServicesKit";
import { bundleManager, common, Want } from '@kit.AbilityKit';
import { pasteboard } from '@kit.BasicServicesKit';
/**
 * app 工具
 */
export class AppUtils {

  /**
   * 将文字copy到剪切板
   * @param text 文本
   * @param action 剪切后动作
   */
  public static copyToClipBoard(text: string, action?: (data: pasteboard.PasteData) => void) {
    const pasteboardData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
    const systemPasteboard = pasteboard.getSystemPasteboard();
    systemPasteboard.setData(pasteboardData); // 将数据放入剪切板
    if (action != null && action !== undefined) {
      systemPasteboard.getData()
        .then((data) => {
          action?.(data)
        })
        .catch(() => {

        })
    }
  }

  /**
   * 跳转浏览器
   */
  public static scanBrowser(context: common.UIAbilityContext, url: string) {
    let want: Want = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: url
    };
    context.startAbility(want)
      .then(() => {
        console.error('Start browsableAbility successfully.');
      })
      .catch((err: BusinessError) => {
        console.error(`Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
      });
  }

  /**
   * 判断是否安装某软件
   */
  isInstalled(bundleName: string): boolean {
    try {
      const data = bundleManager.canOpenLink(bundleName);
      console.log('isInstalled', data.toString())
      if (data) {
        return true
      } else {
        return false
      }
    } catch (err) {
      console.log('isInstalled', JSON.stringify(err))
      return false
    }
  }

  /**
   * 是否安装了支付宝
   */
  isInstalledAlipay(): boolean {
    return this.isInstalled('alipays://')
  }

  /**
   * 是否安装了微信
   */
  isInstalledWechat(): boolean {
    return this.isInstalled('weixin://')
  }

  /**
   * 拉起应用市场对应的应用详情界面
   */
  startAppGalleryDetailAbility(context: common.UIAbilityContext, bundleName: string): Promise<boolean> {
    let want: Want = {
      action: 'ohos.want.action.appdetail',
      uri: 'store://appgallery.huawei.com/app/detail?id=' + bundleName, //  bundleName为需要打开应用详情的应用的包名
    };
    return new Promise((resolve) => {
      context.startAbility(want).then(() => {
        resolve(true);
      }).catch((err: BusinessError) => {
        resolve(false);
      });
    })
  }
}

