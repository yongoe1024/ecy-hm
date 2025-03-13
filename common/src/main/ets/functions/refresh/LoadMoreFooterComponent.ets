import { LoadMoreLayoutStatus } from "@abner/refresh"

/**
 *
 *
 * @author yongoe
 * @since 2025−03-12
 * @version v1.0
 */
@Component
export struct LoadMoreFooterComponent {
  @Prop status: LoadMoreLayoutStatus

  build() {
    Column() {
      if (this.status == LoadMoreLayoutStatus.FooterNothing) {
        Text('没有更多了')
          .fontColor('#999')
          .fontSize(12)
      } else {
        Text('加载更多')
          .fontColor('#999')
          .fontSize(12)
      }
    }
    .width('100%')
    .height(64)
    .justifyContent(FlexAlign.Center)

  }
}

