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
    Column() {
      Text('WebViewPage')

    }
    .width('100%')
    .height('100%')

  }
}

