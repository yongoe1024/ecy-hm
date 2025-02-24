import { UserModel } from "./.."
import { AppStorageName } from "../../constants/AppStorageName"
import { Constants } from "../../constants/Constants"
import { request } from "../netWork/Request"

class UserApi {
  /**
   * 登录并存储token到AppStorage
   */
  async login(phone: string, password: string) {
    let token = await request.post<string>('login', { username: phone, password: password })
    AppStorage.setOrCreate(AppStorageName.TOKEN, token)
  }

  /**
   * 获取用户信息并存到AppStorage
   */
  async getUserInfo() {
    const user = await request.post<UserModel>('/user/info')
    // 仅仅是后端没IP
    user.avatar = Constants.BASE_URL + user.avatar
    AppStorage.setOrCreate(AppStorageName.USER, user)
  }

  /**
   * 获取用户信息并存到AppStorage
   */
  async logout() {
    AppStorage.delete(AppStorageName.USER)
    AppStorage.delete(AppStorageName.TOKEN)
  }
}

export const userApi = new UserApi()