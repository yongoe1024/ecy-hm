import { AppStorageName, UserModel } from "../../../../../Index";

/**
 * 用户管理器
 */
export class UserManager {
  private static instance?: UserManager

  private constructor() {
  }


  public static getInstance(): UserManager {
    if (!UserManager.instance) {
      UserManager.instance = new UserManager()
    }
    return UserManager.instance;
  }

  /**
   * 获取 user
   */
  public get userInfo(): UserModel | undefined {
    return AppStorage.get<UserModel>(AppStorageName.USER)
  }


  public login() {

  }

  public logout() {

  }

  public updateUserInfo() {

  }

  public routeToLogin() {

  }

  /**
   * 判断当前是否登录
   */
  public judgeLogin(): boolean {
    if (this.userInfo !== undefined) {
      return !!this.userInfo.id
    }
    return false
  }
}

