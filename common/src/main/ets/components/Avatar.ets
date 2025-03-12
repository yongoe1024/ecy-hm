/**
 * 头像组件
 * @author yongoe
 * @since 2024/9/8
 */
@ComponentV2
export struct Avatar {
  @Param src: ResourceStr = ''
  @Param avatarSize: number = 20
  @Param radius: number = 0
  @Param onclick: () => void = () => {
  }

  build() {
    Image(this.src)
      .alt($r("app.media.common_ic_avatar"))
      .width(this.avatarSize)
      .height(this.avatarSize)
      .borderRadius(this.radius)
      .objectFit(ImageFit.Fill)
      .onClick(() => {
        this.onclick()
      })
  }
}
