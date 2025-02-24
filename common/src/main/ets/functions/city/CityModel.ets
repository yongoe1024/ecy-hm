/**
 * 城市
 */
export class CityItemModel {
  provinceName?: string;
  provinceCode?: string;
  cityName?: string;
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