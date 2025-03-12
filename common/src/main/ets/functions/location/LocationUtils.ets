import { geoLocationManager } from '@kit.LocationKit';

/**
 * 位置工具
 */
export class LocationUtils {
  /**
   * 逆地理编码
   */
 static  async getAddressByLatLon(lat: number, lon: number): Promise<geoLocationManager.GeoAddress> {
    try {
      // 判断服务可用
      let isAvailable = geoLocationManager.isGeocoderAvailable();
      if (isAvailable) {
        let res =
          await geoLocationManager.getAddressesFromLocation({ "latitude": lat, "longitude": lon, "maxItems": 1 })
        return Promise.resolve(res[0])
      } else {
        return Promise.reject()
      }
    } catch (err) {
      console.error("getCityByLatLon:" + err.code+err.message);
      return Promise.reject()
    }
  }

  static async getAddressesFromName(addressName: string) {
    try {
      // 判断服务可用
      let isAvailable = geoLocationManager.isGeocoderAvailable();
      if (isAvailable) {
        let res = await geoLocationManager.getAddressesFromLocationName({ "description": addressName, "maxItems": 1 })
        return Promise.resolve(res[0])
      } else {
        return Promise.reject()
      }
    } catch (err) {
      console.error("getCityByLatLon:" + JSON.stringify(err));
      return Promise.reject()
    }
  }
}

