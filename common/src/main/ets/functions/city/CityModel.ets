/**
 * 城市
 */
export class CityItemModel{
  // 省份
  provinceName?: string;
  // 省份编码
  provinceCode?: string;
  // 城市
  cityName?: string;
  // 城市编码
  cityCode?: string;
}

/**
 * 分组
 */
export class CityTypeModel {
  public alphabetsName?: string;
  public cities?: CityItemModel[];
}

export const HotCities: CityItemModel[] = []

export const Cities: CityItemModel[] = []