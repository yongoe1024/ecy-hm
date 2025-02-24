import { IBestDialogUtil } from '@ibestservices/ibest-ui'
import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit'


export class PermissionManager {
  /**
   * 获取权限，失败弹窗跳转设置页
   * @param permissions 权限
   * @param failStr 跳转提示信息
   * @returns 成功失败
   */
  static requestPermissions(permissions: Permissions[], failStr: string): boolean {
    const not: Permissions[] = PermissionManager.check(permissions)
    if (not.length == 0) {
      return true
    }
    PermissionManager.request(not)
      .then(res => {
        if (res) {
          return
        }
        IBestDialogUtil.open({
          title: "提示",
          message: failStr,
          showCancelButton: true,
          confirmButtonText: '前往设置',
          onConfirm: () => {
            const context = getContext() as common.UIAbilityContext
            const appInfo =
              bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
            context.startAbility({
              bundleName: "com.huawei.hmos.settings", //设置也的包名
              abilityName: "com.huawei.hmos.settings.MainAbility",
              uri: "application_info_entry", //参数名
              parameters: {
                pushParams: appInfo.name
              }
            })
          }
        })
      })
    return false
  }


  /**
   * 检查是否有权限
   * @param permissions 申请权限
   * @returns 没有的权限
   */
  private static check(permissions: Permissions[]): Permissions[] {
    const manager = abilityAccessCtrl.createAtManager()
    //获取应用信息
    const appInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    const tokenId = appInfo.appInfo.accessTokenId
    //校验每个权限,并返回校验的类型
    const noPermissionList: Permissions[] = []
    permissions.forEach((per) => {
      const res = manager.checkAccessTokenSync(tokenId, per)
      if (res !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        noPermissionList.push(per)
      }
    })
    //处理授权结果
    return noPermissionList
  }

  /**
   * 动态申请权限
   */
  private static async request(permissions: Permissions[]): Promise<boolean> {
    const manager = abilityAccessCtrl.createAtManager()
    const result = await manager.requestPermissionsFromUser(getContext(), permissions)
    const success = result.authResults.every(item => item === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    return success
  }
}
