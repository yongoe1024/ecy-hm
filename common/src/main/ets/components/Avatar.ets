/**
 * 头像组件
 * @author yongoe
 * @since 2024/9/8
 */
@Component
export struct Avatar {
  @Prop src: ResourceStr = ''
  avatarSize: number = 20
  radius: number = 0
  onclick: () => void = () => {
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
