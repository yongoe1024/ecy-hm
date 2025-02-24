/**
 * 路由表
 * 命名规则 {模块名}_{功能名}
 */
export class RouteTable {
  /**
   * web
   */
  public static readonly COMMON_WEB: string = "ecy://common/web";
  /**
   * 登录
   */
  public static readonly ENTRY_LOGIN: string = "ecy://entry/login";
  /**
   * 启动页
   */
  public static readonly ENTRY_LOADING: string = "ecy://entry/loading";
  /**
   * 主页
   */
  public static readonly ENTRY_INDEX: string = "ecy://entry/main";
}