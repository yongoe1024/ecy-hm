import { LengthMetrics } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { IBestToast } from '@ibestservices/ibest-ui';
import { GlobalStyle } from 'common';

@CustomDialog
@Component
export struct SplashPrivacyDialog {
  private context = getContext(this) as common.UIAbilityContext
  cancel?: () => void
  confirm?: () => void
  controller: CustomDialogController

  build() {
    Row() {
      Column() {
        Text('温馨提示')
          .textAlign(TextAlign.Center)
          .fontSize(18)
          .fontColor('#000')
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })

        Row() {
          Text("我们深知个人信息对您的重要性，我们将按法律法规要求，采取相应安全措施，尽全力保护您的个人信息安全可控。")
            .textAlign(TextAlign.Start)
            .fontSize(14)
            .fontColor('#333')
            .margin({ top: 16 })
        }.width('100%')

        Row() {
          Text() {
            Span('在使用 ECY-APP 产品或服务前，请您务必同意')
              .fontSize(14)
              .fontColor('#333')

            Span('《ECY-APP服务协议》')
              .fontColor('#F50537')
              .fontSize(14)
              .onClick(() => {
                IBestToast.show("调到WEB页面或者详情页")
              })
            Span('《隐私政策》')
              .fontColor('#F50537')
              .fontSize(14)
              .onClick(() => {
                IBestToast.show("调到WEB页面或者详情页")
              })

            Span('。若您仍不同意本隐私政策，很遗憾我们将无法为你提供服务。')
              .fontSize(14)
              .fontColor('#333')
          }
          .lineSpacing(LengthMetrics.vp(4))
          .textAlign(TextAlign.Start)
          .fontSize(14)
          .fontColor("#333333")
          .margin({ top: 8 })
        }.width('100%')


        Flex({ justifyContent: FlexAlign.SpaceEvenly }) {
          Text("仍要退出")
            .attributeModifier(GlobalStyle.textModifier('big', 2))
            .layoutWeight(1)
            .onClick(() => {
              if (this.cancel) {
                this.cancel()
              }
            })
            .padding({
              left: 16,
              right: 16
            })

          Divider()
            .width(10)

          Text("同意并继续")
            .attributeModifier(GlobalStyle.textModifier('big', 1))
            .layoutWeight(1)
            .onClick(() => {
              if (this.confirm) {
                this.confirm()
              }
            })
            .padding({
              left: 16,
              right: 16
            })
        }.margin({
          top: 24,
          bottom: 24
        })
      }.margin({ left: 20, right: 20 })
      .borderRadius(0)
      .padding({ left: 20, right: 20 })
      .backgroundColor(Color.White)
    }.width('100%')
  }
}


