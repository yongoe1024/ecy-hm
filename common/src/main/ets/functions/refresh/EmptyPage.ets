/**
 * 空页面
 */
@Component
export struct EmptyPage {

  @Prop emptyImage: Resource = $r('app.media.common_ic_empty_page')
  @Prop emptyText: string = '暂无内容'

  build() {
    Column({ space: 20 }) {
      Image(this.emptyImage)
        .width(185)
        .height(150)
        .margin({
          bottom: 10
        })

      Row() {
        Text(this.emptyText)
          .textAlign(TextAlign.Center)
          .fontSize(14)
          .fontColor('#999')
      }
    }.alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}

