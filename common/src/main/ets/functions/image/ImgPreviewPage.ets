import { GlobalStyle } from "../../globalStyle";
import { RouterParams } from "..";

@Builder
export function ImgPreviewPageBuilder() {
  ImgPreviewPage()
}

/**
 * 图片预览
 */
@Component
export struct ImgPreviewPage {
  /** 入参  **/
  @State imgList: string[] = []
  /** end  **/
  //私有：弹窗控制器
  imageHeight: number = 0 //原始高度；宽度就是屏幕宽
  imageWidth: number = 0 //原始高度；宽度就是屏幕宽
  @State defaultIndex: number = 0 //初始显示的图片索引
  @State index: number = 0 //轮播图切换的图片索引
  @State isGesture: boolean = false //是否缩放轮播图图片了
  @State imgScale: number = 1 //图片默认缩放比例
  @State curScale: number = 1 //当前缩放的比例
  @State imgOffsetX: number = 0 //图片默认x轴
  @State imgOffsetY: number = 0 //图片默认y轴
  @State preOffsetX: number = 0 //上一次移动的x轴
  @State preOffsetY: number = 0 //上一次移动的y轴
  @StorageProp('windowWidth') windowWidth: number = 0;
  @StorageProp('windowHeight') windowHeight: number = 0;

  /**
   * 限制图片放大缩小的比例：保证图片清晰度
   * @param isReset 是否需要重置位置
   */
  limitScale(isReset: boolean) {
    //当前图片的缩放比例是否小于1
    if (this.imgScale < 1) {
      this.imgScale = 1
      this.curScale = 1
      if (isReset) { //位置是否需要复原
        this.imgOffsetX = 0
        this.imgOffsetY = 0
        this.isGesture = false //缩放操作取消掉
      }
    }
    //当前图片的比例是否超过4倍
    else if (this.imgScale > 4) {
      this.imgScale = 4
      this.curScale = 4
    }
    //变换的中途
    else {
      //可以操作，记录下图片的大小比例，应为下一次要继续算下去
      this.curScale = this.imgScale
    }
  }

  /**
   * 限制偏移
   */
  detectBoundary() {
    let maxOffsetX = this.imgScale * this.imageWidth / 2 - this.windowWidth / 2
    if (maxOffsetX <= 0) {
      this.imgOffsetX = 0
    } else if (this.imgOffsetX < -maxOffsetX) {
      this.imgOffsetX = -maxOffsetX
    } else if (this.imgOffsetX > maxOffsetX) {
      this.imgOffsetX = maxOffsetX
    }

    let maxOffsetY = this.imgScale * this.imageHeight / 2 - this.windowHeight / 2
    if (maxOffsetY <= 0) {
      this.imgOffsetY = 0
    } else if (this.imgOffsetY > maxOffsetY) {
      this.imgOffsetY = maxOffsetY
    } else if (this.imgOffsetY < -maxOffsetY) {
      this.imgOffsetY = -maxOffsetY
    }
  }

  build() {
    NavDestination() {
      Stack() {
        Swiper() {
          ForEach(this.imgList, (item: string) => {
            Column() {
              Blank()
              Image(item)
                .width('100%')
                .objectFit(ImageFit.Contain)
                .onComplete(msg => {
                  if (msg) {
                    this.imageWidth = px2vp(msg.componentWidth)
                    this.imageHeight = px2vp(msg.componentHeight)
                  }
                })
                .gesture(
                  PinchGesture()
                    .onActionStart(() => {
                      this.isGesture = true
                    })
                    .onActionUpdate((e) => {
                      this.imgScale = this.curScale * e.scale
                    })
                    .onActionEnd((e) => {
                      this.limitScale(false)
                    })
                )
              Blank()
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
          })
        }
        .loop(false)
        .width('100%')
        .height('100%')
        .index(this.defaultIndex)
        .indicator(false)
        .visibility(this.isGesture ? Visibility.Hidden : Visibility.Visible)
        .onChange((index: number) => {
          // 显示隐藏会触发，没办法
          if (!this.isGesture) {
            this.index = index
          }
          if (this.defaultIndex != this.index) {
            this.defaultIndex = this.index
          }
        })

        Row() {
          Image(this.imgList[this.index])
            .width('100%')
            .objectFit(ImageFit.Contain)
            .translate({ x: this.imgOffsetX, y: this.imgOffsetY })
            .scale({
              x: this.imgScale,
              y: this.imgScale,
              centerX: '50%',
              centerY: '50%'
            })
        }
        .visibility(!this.isGesture ? Visibility.Hidden : Visibility.Visible)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#000')
      .gesture(
        PinchGesture()
          .onActionUpdate((event: GestureEvent) => {
            this.imgScale = this.curScale * event.scale
            this.detectBoundary()
          })
          .onActionEnd((event: GestureEvent) => {
            this.limitScale(true)
          })
      )
      .gesture(
        PanGesture()
          .onActionStart(() => {
            this.preOffsetX = this.imgOffsetX
            this.preOffsetY = this.imgOffsetY
          })
          .onActionUpdate((event: GestureEvent) => {
            this.imgOffsetX = this.preOffsetX + event.offsetX
            this.imgOffsetY = this.preOffsetY + event.offsetY
            this.detectBoundary()
          })
          .onActionEnd((event: GestureEvent) => {

          })
      )
    }
    .attributeModifier(GlobalStyle.navModifier)
    .onReady((context: NavDestinationContext) => {
      if (context.pathInfo && context.pathInfo.param) {
        let params = context.pathInfo.param as RouterParams
        this.imgList = params.get('imgList') as string[] || []
        this.defaultIndex = params.get('showIndex') as number || 0
      }
    })
  }
}