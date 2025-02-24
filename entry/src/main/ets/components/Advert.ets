/**
 * 广告业
 */
@Component
export struct Advert {
  @StorageProp('topRectHeight')
  topRectHeight: number = 0

  build() {
    RelativeContainer() {

      Column({ space: 20 }) {
        Row() {
          Image($rawfile('advert_logo.svg'))
            .width(20)
        }
        .width(50)
        .height(50)
        .borderRadius(50)
        .backgroundColor('#fff')
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)

        Text('NUTS SHOP')
          .fontSize(22)
          .fontWeight(600)
          .letterSpacing(1)
          .fontColor('#fff')
      }
      .alignRules({
        middle: { anchor: "__container__", align: HorizontalAlign.Center },
        top: { anchor: "__container__", align: VerticalAlign.Bottom }
      })
      .offset({
        y: -200
      })

    }
    .height('100%')
    .width('100%')
    .backgroundImage($rawfile('advert_bg.png'))
    .backgroundImageSize({
      width: '100%',
      height: '100%'
    })

  }
}

