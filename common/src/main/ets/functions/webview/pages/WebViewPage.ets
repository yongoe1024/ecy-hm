import { GlobalStyle } from "../../../globalStyle"

@Builder
export function WebViewPageBuilder() {
  WebViewPage()
}

/**
 * web框架
 */
@Component
export struct WebViewPage {
  build() {
    NavDestination() {
      Column() {

      }
    }
    .attributeModifier(GlobalStyle.navModifier)
  }
}

