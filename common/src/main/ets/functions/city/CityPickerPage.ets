import { GlobalStyle } from "../../globalStyle";
import { CityItemModel, CityTypeModel } from "./CityModel";

@Builder
export function CityPickerPageBuilder() {
  CityPickerPage()
}

/**
 * 城市选择页面
 */
@Component
export struct CityPickerPage {
  @State hotCities: CityItemModel[] = [];
  @State allCities: CityTypeModel[] = [];
  @State cities: CityItemModel[] = [];
  @StorageProp('topRectHeight') topRectHeight: number = 0;
  @StorageProp('bottomRectHeight') bottomRectHeight: number = 10;

  aboutToAppear() {
  }

  build() {
    NavDestination() {
      Column() {

      }
    }
    .attributeModifier(GlobalStyle.navModifier)
  }
}