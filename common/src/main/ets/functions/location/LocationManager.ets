import { CityItemModel, PermissionManager } from "..";
import { LocationInfoModel } from "./LocationInfoModel";
import { geoLocationManager } from "@kit.LocationKit";
import { abilityAccessCtrl, Context, common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { LocationUtils } from "./LocationUtils";
import { Logger } from "../../../../../Index";

export class LocationManager {
  private static DEFAULT_LAT: number = 39.904989;
  private static DEFAULT_LNG: number = 116.405285;
  private static DEFAULT_CITY_CODE: string = "110100";
  private static DEFAULT_CITY_NAME: string = "北京市";
  private static DEFAULT_ADDRESS: string = "北京市";
  private static DEFAULT_PROVINCE: string = "北京市";
  private static instance: LocationManager;
  private info: LocationInfoModel = new LocationInfoModel()
  locationRequest: geoLocationManager.SingleLocationRequest = {
    // 快速定位策略(PRIORITY_LOCATING_SPEED)
    'locatingPriority': geoLocationManager.LocatingPriority.PRIORITY_LOCATING_SPEED,
    // 超时时间设置为10秒
    'locatingTimeoutMs': 10000
  }

  private constructor() {
    this.info.latitude = LocationManager.DEFAULT_LAT
    this.info.longitude = LocationManager.DEFAULT_LNG
    this.info.cityName = LocationManager.DEFAULT_CITY_NAME
    this.info.cityCode = LocationManager.DEFAULT_CITY_CODE
    this.info.address = LocationManager.DEFAULT_ADDRESS
    this.info.province = LocationManager.DEFAULT_PROVINCE
  }

  public static getInstance(): LocationManager {
    if (!LocationManager.instance) {
      LocationManager.instance = new LocationManager();
    }
    return LocationManager.instance;
  }

  async updateInfo(): Promise<void> {
    try {
      await this.init()
      // WGS-84坐标系坐标点
      let result = await geoLocationManager.getCurrentLocation(this.locationRequest)
      this.info.latitude = result.latitude
      this.info.longitude = result.longitude
      let res = await LocationUtils.getAddressByLatLon(0, 0)
      console.log(JSON.stringify(res))
    } catch (err) {
      Logger.error('updateInfo 获取失败')
    }
  }

  async init(): Promise<void> {
    try {
      // 请求权限
      let res = await PermissionManager.requestPermissions(
        ["ohos.permission.APPROXIMATELY_LOCATION", "ohos.permission.LOCATION"],
        '无法获取定位权限，请前往系统设置中开启')
      if (!res) {
        return Promise.reject()
      }
      let locationEnabled = geoLocationManager.isLocationEnabled();
      if (!locationEnabled) {
        // 打开定位设置
        res = await this.openSet()
        if (!res) {
          return Promise.reject()
        }
      }
      return Promise.resolve()
    } catch (e) {
      console.error('LocationManager :' + e.code + e.message)
      return Promise.reject()
    }
  }

  /**
   * 打开定位
   */
  openSet(): Promise<boolean> {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let context: Context = getContext(this) as common.UIAbilityContext;
    return atManager.requestGlobalSwitch(context, abilityAccessCtrl.SwitchType.LOCATION)
  }


  public getLocationInfo(): LocationInfoModel {
    let model = new LocationInfoModel()
    model.latitude = this.info.latitude
    model.longitude = this.info.longitude
    model.cityName = this.info.cityName
    model.cityCode = this.info.cityCode
    model.address = this.info.address
    model.province = this.info.province
    return model
  }

  public getLat(): number {
    return this.info.latitude
  }

  public getLng(): number {
    return this.info.longitude
  }

  public getCityName(): string {
    return this.info.cityName
  }

  public getCityCode(): string {
    return this.info.cityCode
  }

  public getCityProvince(): string {
    return this.info.province
  }

  public getAddress(): string {
    return this.info.address
  }

  public getCityInfo(): CityItemModel {
    let cityModel = new CityItemModel()
    cityModel.cityName = this.info.cityName
    cityModel.cityCode = this.info.cityCode
    return cityModel
  }

  public isCurrentCity(cityCode: string, cityName: string): Boolean {
    return this.info.cityCode == cityCode || this.info.cityName == cityName
  }
}
