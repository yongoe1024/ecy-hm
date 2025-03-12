/**
 * 错误页面
 */
@Component
export struct ErrorPage {
  @Require reset: () => void = () => {
  }
  @Prop code: number
  @State icon: string | Resource | PixelMap = '';
  @State message: string | Resource = '';
  @State buttonText: string | Resource = "再试一次";
  private info: Record<number, Record<string, string | Resource>> = {
    501: {
      'icon': $r('app.media.common_ic_empty_page'),
      'message': '网络不可用，请检查网络设置'
    },
    502: {
      'icon': $r('app.media.common_ic_empty_page'),
      'message': '服务超时，请稍后再试'
    },
    503: {
      'icon': $r('app.media.common_ic_empty_page'),
      'message': '请求出错，请稍后再试'
    },
    500: {
      'icon': $r('app.media.common_ic_empty_page'),
      'message': '请稍后重试'
    }
  }

  aboutToAppear(): void {
    this.getInfo(this.code)
  }

  private getInfo(code: number): void {
    let tmp: Record<string, string | Resource> | null = null;
    switch (code) {
      case 500:
        tmp = this.info[500];
        break;
      case 501:
        tmp = this.info[501];
        break;
      case 502:
        tmp = this.info[502];
        break;
      case 503:
        tmp = this.info[503];
        break;
      case 503:
        tmp = this.info[504];
        break;
      default:
        tmp = this.info[500];
        break;
    }
    this.icon = tmp.icon;
    this.message = tmp.message;
  }

  build() {
    Column() {
      Image(this.icon)
        .width(185)
        .height(150)
        .margin({
          bottom: 20
        })

      Text(this.message)
        .textAlign(TextAlign.Center)
        .fontSize(14)
        .fontColor('#999')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text(this.buttonText)
        .fontSize(14)
        .fontColor('#fff')
        .backgroundColor('#000')
        .margin({ top: 20 })
        .padding({
          left: 16,
          top: 8,
          right: 16,
          bottom: 8
        })
        .onClick(() => {
          this.reset();
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

