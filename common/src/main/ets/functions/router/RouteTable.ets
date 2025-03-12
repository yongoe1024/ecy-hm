/**
 * 路由表
 * 命名规则 {模块名}_{功能名}
 */
export class RouteTable {
  /** common  **/
  // web
  public static readonly COMMON_WEB: string = "ecy://common/web";
  // 城市选择
  public static readonly CITY_PICKER: string = "ecy://common/city";
  // 图片预览
  public static readonly IMG_PREVIEW: string = "ecy://common/img_preview";
  // 图片裁剪
  public static readonly IMG_CROP: string = "ecy://common/img_crop";


  /** entry  **/
   // 登录
  public static readonly ENTRY_LOGIN: string = "ecy://entry/login";
  /// 启动页
  public static readonly ENTRY_LOADING: string = "ecy://entry/loading";
  // 主页
  public static readonly ENTRY_INDEX: string = "ecy://entry/main";
}