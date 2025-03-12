/**
 * 加载页面
 */
@Component
export struct LoadingPage {
  build() {
    Column() {
      Row() {
        LoadingProgress().height(30)
        Text('加载中...')
      }

    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)

  }
}

